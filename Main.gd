extends Node2D
signal show_answer

# TODO:
# - Add a skip button
#    - Skip button can only be used in the first N seconds
# - Create logging variables
# - Staircasing difficulty and cost of calculator
# 	-Have fewer classes of problems in order to avoid this non-linear ramp up

#var qs = preload("res://questions.gd")
var questions = []
var difficulties = []
var new_questions = []
var new_difficulties = []
var question = 0 # keep track of where we are in the block
var feedbackColor = Color(0, 1, 0, 1);
var CALC_DELAY = 0.1 # to open calc
var MAX_DELAY = 3 # to get answer from equal
var QUESTION_TIME = 20;
var BLOCK_SIZE = 11;
var TAR_CALC_USE_HARD = 5; # we want the user to use the calc 5 times
var TAR_CALC_USE_EASY = 0;
var num_easy = 5
var num_hard = BLOCK_SIZE - 1 - num_easy
var block_accuracy = 0
var calc_use_easy = 0
var calc_use_hard = 0
var delta_qtime = 0.1
var qtime = 0;
var random = RandomNumberGenerator.new()

# Define levels
var level_hard = 5
var level_easy = 1
var LEVELS = [
	[1, 1, 1, 1, 1], # Level 1: 4+3      #  2 2
	[1, 1, 2, 3, 1], # Level 2: 8+7+2    #  3 3 3
	[1, 2, 1, 1, 1], # Level 3: 4+13     #  5 5 5 5 5 <--- starting mean
	[1, 1, 3, 4, 1], # Level 4: 6+3+8+7  #  3 3 3
	[1, 2, 2, 2, 1], # Level 5: 7+4+46   #  2 2
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
var e = LEVELS[level_easy-1]
var h = LEVELS[level_hard-1]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	random.randomize()
	var qs = generate_block(BLOCK_SIZE, num_easy, e, h)
	questions = qs[0]
	print(questions)
	difficulties = qs[1]
	print(difficulties)

	$problem/questionTimeProg.value = $problem/questionTimeProg.max_value
	#$questionTimer.start(delta_qtime)
	$problem/answer.text = ''
	$problem.text = questions[question][0]
	$taskTimer.start(1)
	$calculator.visible = false
	$calcButton.text =  'Calculator'
	$feedback.visible = false
	$wheel.visible = false
	$wheel.modulate = Color(.58, .89, .85, 0.85)
	$easterEgg.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$wheel.rotation_degrees += round(0.021/max(delta, 0.006)) # try to keep this constant
	if $wheel.rotation_degrees >= 360:
		$wheel.rotation_degrees = 0 
		
func _input(ev):
	if ev.is_action_released("ui_accept"):
		_on_submit_pressed()

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

func create_problem(min_dig, max_dig, num_ops, num_min=1, num_max=1):
	var ops = []
	for _i in range(num_min):
		ops.append(generate_number(min_dig))

	for _i in range(num_max):
		ops.append(generate_number(max_dig))

	if (num_max + num_min - 1) > num_ops:
		num_ops = num_max + num_min - 1
		print('Warning: num_ops smaller than num_max + num_min - 1; using sum - 1 as num_ops')

	# Populate remaining operators
	for i in range(num_ops - (num_max + num_min - 1)):
		ops.append(generate_number(random.randi_range(min_dig, max_dig)))

	# Generate label str and compute answer
	var problem = ''
	var answer = 0
	for op in ops:
		problem += op + '+'
		answer += int(op)
	problem = problem.substr(0, len(problem)-1)
	
	return [problem, answer]
	
func generate_block(block_size, num_easy, e, h):
	var questions_ = []; var questions__ = []
	var difficulty_ = []; var difficulty__ = []
	for j in range(num_easy):
		questions_.append(create_problem(e[0], e[1], e[2], e[3], e[4]))
		difficulty_.append('e')
	for j in range(block_size - 1 - num_easy):
		questions_.append(create_problem(h[0], h[1], h[2], h[3], h[4]))
		difficulty_.append('h')
	
	# Generate index array, shuffle
	var ix = range(block_size-1)
	random.randomize()
	ix.shuffle()
	print(ix)
	for i in ix:
		questions__.append(questions_[i])
		difficulty__.append(difficulty_[i])
	
	# Final question always easy
	questions__.append(create_problem(e[0], e[1], e[2], e[3], e[4]))
	difficulty__.append('e')
	print(questions__)
	print(difficulty__)
	
	return [questions__, difficulty__]

func _on_Button_pressed():
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

func modulate_difficulty(difficulties, tar_hard, tru_hard, tar_easy, tru_easy):
	# Use calculator use to modulate difficulty
	print('A')

func next_question():
	$calculator.visible = false
	$wheel.visible = false
	$calculator.stored = 0
	$calculator.currentOp = ""
	$calculator/Panel/VBoxContainer/Display.set_text(str(0))

	# Increment question
	question += 1
	if question == BLOCK_SIZE - 1:
		print('FINAL BLOCK')
		# Use calculator use to modulate difficulty
		if calc_use_easy > TAR_CALC_USE_EASY:
			print('Making easy problems harder')
			level_easy = max(1, level_easy-1)
		else:
			print('Making easy problems easier')
			level_easy = min(level_hard, level_easy+1)
		if calc_use_hard <= TAR_CALC_USE_HARD:
			print('Making hard problems harder')
			level_hard = min(len(LEVELS), level_hard+1)
		else:
			print('Making hard problems easier')
			level_hard = max(level_easy, level_hard-1)
		
		var qs = generate_block(BLOCK_SIZE, num_easy, 
								LEVELS[level_easy], LEVELS[level_hard])
		new_questions = qs[0]
		new_difficulties = qs[1]
	elif question == BLOCK_SIZE:
		question = 0
		questions = new_questions
		difficulties = new_difficulties
	else:
		print('Question ' + str(question))
	
	$problem.text = questions[question][0]
	$problem/answer.text = ''
	$problem/answer.grab_focus()

func _on_submit_pressed():
	if int($problem/answer.text) == questions[question][1]:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)+1)
		$feedback.bbcode_text = '[color=#00FF00]+1[/color]'
		block_accuracy += 1 / (BLOCK_SIZE - 1)
	else:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)-1)
		$feedback.bbcode_text = '[color=#FF0000]-1[/color]'
	if int($problem/answer.text) == 28980 / (60 * 7):
		$easterEgg.modulate.a = 1
		$easterEgg.visible = true
		$easterEggTimer.start(0.05)
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
