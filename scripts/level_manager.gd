extends Node2D
#on stage change to 2, spawn 'go home' word that doesn't disappear
#^where do we do this? did we want a timer?

@onready var wordScene = load("res://scenes/word.tscn")
@onready var outsideBackground = $background/outside_parallax2d
@onready var insideBackground = $background/inside_parallax2d

func _ready() -> void:
	$WordTimer.start(1.0) #delay from opening to first word spawning
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
	$WordTimer.start(Globals.wordSpawnTime)
		


func _start_stage_1() -> void:
	Globals.stage = 1
	#TODO: play animation to fade to black->fade to outside
	outsideBackground.visible = true
	insideBackground.visible = false


func _scroll_background(speed: float) -> void:
	outsideBackground.autoscroll.x = speed
