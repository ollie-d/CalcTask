extends Node2D
signal show_answer

# TODO:
# - Logging variables
#	- log time of every button/key press in ms
#	- log every question
#	- log every answer
#	- log accuracy
#	- log mean level
# Save things in a JSON (dict of ndicts of ndicts...)
# {
#	block_1
#	{
#		start_time: 1ms
#		mean_level: 3
#		q1: 
#		{
#			time_left: 300
#			question_display_time: 2ms
#			question: '2+3'
#			correct_answer: 5
#			user_answer: 5
#			user_correct: True
#			answer_time: 20ms
#			used_calculator: True
#			score: 1
#			events: 
#			[
#				(press_calc, 1ms),
#				('calc_3', 2ms),
#				('calc_+', 3ms),
#				('calc_2', 4ms),
#				('calc_=', 5ms),
#				('key_5', 6ms),
#				('submit, 7ms)
#			]
#		}
#	}
#}
var data = {'sid':'', 'block_data':{}}
var sid = ''
export var websocket_url = "ws://70.95.172.59:8765"
var _client = WebSocketClient.new()

var questions = []
var difficulties = []
var new_questions = []
var new_difficulties = []
var question = -1 # keep track of where we are in the block
var feedbackColor = Color(0, 1, 0, 1);
var CALC_DELAY = 0.01 # to open calc
var MAX_DELAY = 0.01 # to get answer from equal
var QUESTION_TIME = 20; # unused
var block_accuracy = 0
var block_counter = 0
var BLOCK_PFX = 'block_'
var block_id = BLOCK_PFX + str(block_counter)
var Q_PFX = 'q'
var question_id = Q_PFX + str(question)
var delta_qtime = 0.1
var qtime = 0;
var random = RandomNumberGenerator.new()

# Define levels
var LEVELS = [
	[1, 1, 1, 2, 0], # Level 1: 4+3      #  1
	[1, 1, 2, 3, 0], # Level 2: 8+7+2    #  2 2
	[1, 2, 1, 1, 1], # Level 3: 4+13     #  3 3 3 <--- starting mean
	[1, 1, 3, 4, 0], # Level 4: 6+3+8+7  #  2 2
	[1, 2, 2, 2, 1], # Level 5: 7+4+46   #  1
	[2, 2, 1, 0, 2], # Level 6: 23+78
	[1, 2, 3, 3, 1], # Level 7: 3+8+6+57
	[1, 2, 2, 1, 2], # Level 8: 7+23+78
	[2, 3, 1, 1, 1], # Level 9: 23+103
	[2, 2, 3, 0, 4], # Level 10: 57+23+78+46
	[2, 3, 2, 2, 1], # Level 11: 41+28+345
	[2, 3, 3, 3, 1], # Level 12: 41+57+28+345
	[3, 3, 2, 0, 3], # Level 13: 145+341+932
	[3, 3, 3, 0, 4]  # Level 14: 666+145+341+932
]
var level_mean = 3
var level_distribution = [1, 2, 3, 2, 1]
var BLOCK_SIZE = sum(level_distribution) + 1;
var TAR_CALC_USE_HARD = 4; # ~70% of hard trials
var TAR_CALC_USE_EASY = 1; # if they do more than this, decrease
var calc_use_easy = 0
var calc_use_hard = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Define name
	var c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	var ix = range(36)
	random.randomize()
	randomize()
	ix.shuffle()
	for i in range(12):
		sid += c[ix[i]]
	data['sid'] = sid
	# Set up networking stuff
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		
	# Get calculator delay from server
	MAX_DELAY = MAX_DELAY
	data['calc_equals_delay'] = MAX_DELAY
	
	set_process_input(true)
	# Add data to our JSON
	data['block_data'][block_id] = {}
	data['block_data'][block_id]['mean_level'] = level_mean
	data['block_data'][block_id]['start_time'] = OS.get_ticks_msec()
	data['block_data'][block_id]['questions'] = {}
	var qs = generate_block(level_mean, level_distribution)
	questions = qs[0]
	difficulties = qs[1]

	next_question()
	$problem/questionTimeProg.value = $problem/questionTimeProg.max_value
	#$questionTimer.start(delta_qtime)
	$problem/answer.text = ''
	#data['block_data'][block_id]['questions'][question_id] = {}
	#data['block_data'][block_id]['questions'][question_id]['time_left_start'] = $timeLeft/timer.text
	#data['block_data'][block_id]['questions'][question_id]['question_display_time'] = OS.get_ticks_msec()
	$problem.text = questions[question][0]
	#data['block_data'][block_id]['questions'][question_id]['question'] = questions[question][0]
	#data['block_data'][block_id]['questions'][question_id]['correct_answer'] = questions[question][1]
	#data['block_data'][block_id]['questions'][question_id]['events'] = []
	$taskTimer.start(1)
	$calculator.visible = false
	$calcButton.text =  'Calculator'
	$feedback.visible = false
	$wheel.visible = false
	$wheel.modulate = Color(.58, .89, .85, 0.85)
	$easterEgg.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_client.poll()
	$wheel.rotation_degrees += round(0.021/max(delta, 0.006)) # try to keep this constant
	if $wheel.rotation_degrees >= 360:
		$wheel.rotation_degrees = 0 

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)
	
func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	
func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _send_data(data):
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _input(ev):
	if ev.is_action_released("ui_accept"):
		_on_submit_pressed()

func sum(list):
	var ans = 0
	for l in list:
		ans += l
	return ans

func generate_number(num_dig):
	# Restrict final digit from being 0, 1, 2 or 5
	var choices_f = [3, 4, 6, 7, 8, 9]
	var choices_i = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	var len_f = len(choices_f)-1
	var len_i = len(choices_i)-1

	var q = ''
	for _j in range(num_dig-1):
		q += str(choices_i[random.randi_range(0, len_i)])
	q += str(choices_f[random.randi_range(0, len_f)])
	
	return q

func create_problem(args):
	var min_dig = args[0] 
	var max_dig = args[1]
	var num_ops = args[2]
	var num_min = args[3]
	var num_max = args[4]
	var ops = []
	for _i in range(num_min):
		ops.append(generate_number(min_dig))

	for _i in range(num_max):
		ops.append(generate_number(max_dig))

	if (num_max + num_min - 1) > num_ops:
		num_ops = num_max + num_min - 1
		print('Warning: num_ops smaller than num_max + num_min - 1; using sum - 1 as num_ops')

	# Populate remaining operators
	for _i in range(num_ops - (num_max + num_min - 1)):
		ops.append(generate_number(random.randi_range(min_dig, max_dig)))

	# Generate label str and compute answer
	var problem = ''
	var answer = 0
	for op in ops:
		problem += op + '+'
		answer += int(op)
	problem = problem.substr(0, len(problem)-1)
	
	return [problem, answer]
	
func generate_block(level_mean_, level_distribution_):
	if len(level_distribution_) % 2 == 0:
		print('ERROR, level distribution should be odd')
		#level_distribution_ = level_distribution_[:-1]
	# Make sure we're never below minimum mean
	var min_mean = int(((len(level_distribution_)-1)/2)+1)
	level_mean_ = max(level_mean_, min_mean)
	# Or max mean
	var max_mean = len(LEVELS) - int(((len(level_distribution_)-1)/2))
	level_mean_ = min(level_mean_, max_mean)

	print('Mean level: %d' % level_mean_)
	var level_range = range(int(level_mean_-((len(level_distribution_)-1)/2)),
						int(level_mean_+((len(level_distribution_)-1)/2))+1) 

	# Initiate questions and iterate through levels and generate questions
	var questions_ = [];  var questions__ = []
	var difficulty_ = []; var difficulty__ = []
	for i in range(len(level_distribution_)):
		var lvl = level_range[i]
		for _j in range(level_distribution_[i]):
			questions_.append(create_problem(LEVELS[lvl-1]))
			if lvl < level_mean_:
				difficulty_.append('e');
			else:
				difficulty_.append('h')

	# Final question always easy
	var ix = range(len(questions_))
	random.randomize()
	randomize()
	ix.shuffle()
	for i in ix:
		questions__.append(questions_[i])
		difficulty__.append(difficulty_[i])

	# Final question always easy
	questions__.append(create_problem(LEVELS[level_range[0]-1]))
	difficulty__.append('e')
	
	return [questions__, difficulty__]

func _on_Button_pressed():
	data['block_data'][block_id]['questions'][question_id]['events'].append(['open_calc', OS.get_ticks_msec()])
	data['block_data'][block_id]['questions'][question_id]['calculator_opened'] = 'True'
	$calcTimer.start(CALC_DELAY) # delay calc opening
	$calcButton.disabled = true
	able_calculator(false)

func _on_calcTimer_timeout():
	$calcTimer.stop()
	able_calculator(true)
	$calculator.visible = !$calculator.visible
	$calcButton.disabled = false

func _on_taskTimer_timeout():
	$timeLeft/timer.text = str(int($timeLeft/timer.text) - 1)
	if int($timeLeft/timer.text) == 0:
		$taskTimer.stop()

func calc_diff(lvl_, tar_h, tru_h, tar_e, tru_e):
	# Use calculator use to modulate difficulty
	print('True hard calc usage: ' + str(tru_h))
	print('Target hard calc usage: ' + str(tar_h))
	print('True easy calc usage: ' + str(tru_e))
	print('Target easy calc usage: ' + str(tar_e))
	var lvl__ = lvl_
	print(tru_h < tar_h)
	print(tar_e <= tru_e)
	if ((tru_h < tar_h) and (tru_e <= tar_e)):
		print('True1')
		lvl__ += 1
	if ((tru_h > tar_h) and (tru_e > tar_e)):
		print('True2')
		lvl__ -= 1
	print(lvl__)
	return lvl__

func next_question():
	$calculator.visible = false
	$wheel.visible = false
	$calculator.stored = 0
	$calculator.currentOp = ""
	$calculator/Panel/VBoxContainer/Display.set_text(str(0))

	# Increment question
	question += 1
	question_id = Q_PFX + str(question)
	
	if question == BLOCK_SIZE - 1:
		print('FINAL BLOCK')
		level_mean = calc_diff(level_mean, TAR_CALC_USE_HARD, calc_use_hard,
										   TAR_CALC_USE_EASY, calc_use_easy)
		var qs = generate_block(level_mean, level_distribution)
		new_questions = qs[0]
		new_difficulties = qs[1]
	elif question == BLOCK_SIZE:
		# Reset statistics
		calc_use_easy = 0
		calc_use_hard = 0
		
		block_counter += 1
		block_id = BLOCK_PFX + str(block_counter)
		# Add data to our JSON
		data['block_data'][block_id] = {}
		data['block_data'][block_id]['mean_level'] = level_mean
		data['block_data'][block_id]['start_time'] = OS.get_ticks_msec()
		data['block_data'][block_id]['questions'] = {}
		question = 0
		question_id = Q_PFX + str(question)
		questions = new_questions
		difficulties = new_difficulties
	else:
		print('Question ' + str(question))
	
	# Set up data storage for next question
	print('creating new data entry for block: %s question: %s' % [block_id, question_id])
	data['block_data'][block_id]['questions'][question_id] = {}
	data['block_data'][block_id]['questions'][question_id]['time_left_start'] = $timeLeft/timer.text
	data['block_data'][block_id]['questions'][question_id]['question_time_start'] = OS.get_ticks_msec()
	data['block_data'][block_id]['questions'][question_id]['question'] = questions[question][0]
	data['block_data'][block_id]['questions'][question_id]['correct_answer'] = questions[question][1]
	data['block_data'][block_id]['questions'][question_id]['events'] = []
	print(data['block_data'][block_id]['questions'][question_id])
	$problem.text = questions[question][0]
	$problem/answer.text = ''
	$problem/answer.grab_focus()

func _on_submit_pressed():
	print('submit: block_id: ' + str(block_id) + ', question_id: ' + str(question_id))
	print(data['block_data'][block_id]['questions'][question_id])
	data['block_data'][block_id]['questions'][question_id]['time_left_end'] = $timeLeft/timer.text
	data['block_data'][block_id]['questions'][question_id]['answered_time'] = OS.get_ticks_msec()
	data['block_data'][block_id]['questions'][question_id]['events'].append(['submit', OS.get_ticks_msec()])
	data['block_data'][block_id]['questions'][question_id]['user_answer'] = $problem/answer.text
	if int($problem/answer.text) == questions[question][1]:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)+1)
		$feedback.bbcode_text = '[color=#00FF00]+1[/color]'
		data['block_data'][block_id]['questions'][question_id]['user_correct'] = 'True'
		block_accuracy += 1 / (BLOCK_SIZE - 1)
	else:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)-1)
		$feedback.bbcode_text = '[color=#FF0000]-1[/color]'
		data['block_data'][block_id]['questions'][question_id]['user_correct'] = 'False'
	if int($problem/answer.text) == 28980 / (60 * 7):
		$easterEgg.modulate.a = 1
		$easterEgg.visible = true
		$easterEggTimer.start(0.05)
	
	data['block_data'][block_id]['questions'][question_id]['score'] = $scoreLabel/score.text
	$feedback.modulate.a = 1
	$feedback.visible = true
	$feedbackTimer.start(0.1)
	next_question()

func _on_feedbackTimer_timeout():
	# Make transparent
	$feedback.modulate.a -= 0.2;
	if $feedback.modulate.a == 0:
		$feedbackTimer.stop()
		$feedback.visible = false

func _on_calculator_equals_pressed():
	data['block_data'][block_id]['questions'][question_id]['used_calculator'] = 'True'
	if difficulties[question] == 'e':
		calc_use_easy += 1
	elif difficulties[question] == 'h':
		calc_use_hard += 1
	able_calculator(false)
	$wheel.visible = true
	$equalTimer.start(MAX_DELAY) # subtract time elapsed so far

func able_calculator(x):
# If true, enable, if false, disable
	if !x:
		for child in $calculator.NumPad.get_children():
			child.disabled = true
		for child in $calculator.OpPad.get_children():
			child.disabled = true
	else:
		for child in $calculator.NumPad.get_children():
			child.disabled = false
		for child in $calculator.OpPad.get_children():
			child.disabled = false

func _on_equalTimer_timeout():
	$equalTimer.stop()
	emit_signal("show_answer")
	able_calculator(true)
	$wheel.visible = false

func _on_easterEggTimer_timeout():
	$easterEgg.modulate.a -= 0.2
	if $easterEgg.modulate.a == 0:
		$easterEggTimer.stop()
		$easterEgg.visible = false

func _on_questionTimer_timeout():
	var sub = $problem/questionTimeProg.max_value / (QUESTION_TIME/delta_qtime)
	$problem/questionTimeProg.value = $problem/questionTimeProg.value - sub

	if $problem/questionTimeProg.get_value() <= 0:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)-1)
		$feedback.bbcode_text = '[color=#FF0000]-1[/color]'
		$feedback.modulate.a = 1
		$feedback.visible = true
		$feedbackTimer.start(0.1)
		
		next_question()

func _on_socketButton_pressed():
	_send_data(data)

func _notification(what):
	# Exit gracefully
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		_send_data({'sid': sid, 'earlyTermination': 'True'})
		_client.disconnect_from_host()
		get_tree().quit() # default behavior

func _on_dictButton_pressed():
	$RichTextLabel.text =  JSON.print(data, "\t")
	#JSON.print(data, "\t"))

func _on_calculator_button_pressed(button):
	data['block_data'][block_id]['questions'][question_id]['events'].append(['calc_'+str(button), OS.get_ticks_msec()])
