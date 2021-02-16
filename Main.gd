extends Node2D
signal show_answer

# TODO:
# - Enter for submit button
# - Bigger calculator size
# - Hide question timer and add a skip button
#    - Skip button can only be used in the first N seconds
# - Maximum question delay on wheel for any question
#    - Take maximum time minus time spent on problem
#    * MAX TIME MINUS TIME TAKEN ENTERING VALUES


# Create logging variables

# Declare member variables here. Examples:
#var questions = [
#	['1+1', 2],
#	['2+2', 4],
#	['3+3', 6]
#]

var qs = preload("res://questions.gd")
var questions
var question = 0
var feedbackColor = Color(0, 1, 0, 1);
var CALC_DELAY = 0.1
var MAX_DELAY = 3
var QUESTION_TIME = 20;
var delta_qtime = 0.1
var qtime = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	var questions_ = qs.new() # load questions
	# TEMP: Set to all levels and shuffle
	questions = questions_.lvl1 # TEMP: set questions to level X
	questions += questions_.lvl2
	questions += questions_.lvl3
	questions += questions_.lvl4
	questions += questions_.lvl5
	questions += questions_.lvl6
	questions += questions_.lvl7
	randomize()
	questions.shuffle()
	
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
	$wheel.rotation_degrees += 3
	if $wheel.rotation_degrees == 360:
		$wheel.rotation_degrees = 0 
		
func _input(ev):
	if ev.is_action_released("ui_accept"):
		_on_submit_pressed()

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

func next_question():
	$calculator.visible = false
	$wheel.visible = false
	$calculator.stored = 0
	$calculator.currentOp = ""
	$calculator/Panel/VBoxContainer/Display.set_text(str(0))
	
	# Increment question
	question += 1
	if question >= len(questions):
		question = 0
	$problem.text = questions[question][0]
	$problem/answer.text = ''
	
	# Set focus back to answer box for convenience
	$problem/answer.grab_focus()
	
	# Refresh questionTimer
	#$questionTimer.stop()
	#$problem/questionTimeProg.set_value($problem/questionTimeProg.max_value)
	#$problem/questionTimeProg.value = $problem/questionTimeProg.max_value
	#$questionTimer.start(delta_qtime)

func _on_submit_pressed():
	if int($problem/answer.text) == questions[question][1]:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)+1)
		$feedback.bbcode_text = '[color=#00FF00]+1[/color]'
	else:
		$scoreLabel/score.text = str(int($scoreLabel/score.text)-1)
		$feedback.bbcode_text = '[color=#FF0000]-1[/color]'
	if int($problem/answer.text) == 69:
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
