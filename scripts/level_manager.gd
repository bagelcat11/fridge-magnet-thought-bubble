extends Node2D
#on stage change to 2, spawn 'go home' word that doesn't disappear
#^where do we do this? did we want a timer?

@onready var wordScene = load("res://scenes/word.tscn")
@onready var outsideBackground = $background/outside_parallax2d
@onready var insideBackground = $background/inside_parallax2d
signal _send_player_home()

func _ready() -> void:
	$word_timer.start(1.0) #delay from opening to first word spawning
	outsideBackground.visible = false
	insideBackground.visible = true
	outsideBackground.autoscroll.x = Globals.defaultScrollSpeed
	
func _physics_process(delta: float) -> void:
	pass

func _on_word_timer_timeout() -> void:
	#if (Globals.stage == 0):
		#pass #spawn the 'get up' words
	#elif (Globals.stage == 1 || Globals.stage == 2):
		#spawn the normal words (until we run out? or do we cycle?)
	#TODO: need to make sure words don't spawn in the bubble
	var newWord = wordScene.instantiate()
	var rand_x = randi() % int(get_viewport().get_visible_rect().size.x)
	var rand_y = randi() % int(get_viewport().get_visible_rect().size.y)
	#print("rand_x: ", rand_x)
	#print("rand_y: ", rand_y)
	newWord.set_position(Vector2(rand_x, rand_y))
	add_child(newWord)
	newWord.add_to_group("words")
	$word_timer.start(Globals.wordSpawnTime)
		


func _start_stage_1() -> void:
	Globals.stage = 1
	#TODO: play animation to fade to black->fade to outside
	outsideBackground.visible = true
	insideBackground.visible = false
	$end_timer.start(Globals.walkTime)


func _scroll_background(speed: float) -> void:
	outsideBackground.autoscroll.x = speed


func _on_end_timer_timeout() -> void:
	if (Globals.stage == 1):
		Globals.stage = 2
	elif (Globals.stage == 2):
		#delete the words
		for word in get_tree().get_nodes_in_group("words"):
			word.queue_free()
		#show end screen
		$end.visible = true
		#print("ee")
		Globals.stage = 3
		#this is so temporary..


func _go_home() -> void:
	#mirror player
	#do we want to erase all the words? 
	#or just change the direction they will move when they 
	#turn into a moving word if they aren't one?
	#also we may need an asset for the home they came out of at the start..
	#or we can just turn around and cut to black and be all dramatic
	#for now ill do that
	
	_send_player_home.emit()
	#print("sending player home")
	outsideBackground.autoscroll.x = -Globals.defaultScrollSpeed
	$end_timer.start(Globals.endDelayTime)
