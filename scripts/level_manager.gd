extends Node2D
#on stage change to 2, spawn 'go home' word that doesn't disappear
#^where do we do this? did we want a timer?

@onready var wordScene = load("res://scenes/word.tscn")
@onready var outsideBackground = $background/outside_parallax2d
@onready var insideBackground = $background/inside_parallax2d
@onready var homeBackground = $background/home_parallax2d
@onready var bubbleRect = $bubble/word_area/CollisionShape2D.shape.get_rect()
@onready var screenPadding = 50
@onready var bubblePadding = 10
#so sorry for all these variables
@onready var viewport_x = get_viewport().get_visible_rect().size.x
@onready var viewport_y = get_viewport().get_visible_rect().size.y
	
@onready var screen_low_x = screenPadding
@onready var screen_high_x = viewport_x - screenPadding - Globals.word_w
@onready var screen_low_y = screenPadding
@onready var screen_high_y = viewport_y - screenPadding - Globals.word_h
	
@onready var bubblePosition = Vector2($bubble/word_area/CollisionShape2D.global_position.x - (bubbleRect.size.x / 2), $bubble/word_area/CollisionShape2D.global_position.y - (bubbleRect.size.y / 2))
@onready var bubble_low_x = bubblePosition.x - Globals.word_w - bubblePadding
@onready var bubble_high_x = bubblePosition.x + bubbleRect.size.x
@onready var bubble_low_y = bubblePosition.y - Globals.word_h - bubblePadding
@onready var bubble_high_y = bubblePosition.y + bubbleRect.size.y

var currentShaders = {}
signal _send_player_home()

func _ready() -> void:
	$word_timer.start(1.0) #delay from opening to first word spawning
	outsideBackground.visible = false
	insideBackground.visible = true
	outsideBackground.autoscroll.x = Globals.defaultScrollSpeed
	$player.global_position = Vector2(1001, 722)
	
func _physics_process(delta: float) -> void:
	#print($background/outside_parallax2d/sprite/ColorRect/VisibleOnScreenNotifier2D.is_on_screen())
	pass

func _on_word_timer_timeout() -> void:	
	#var bubbleColorRect = ColorRect.new()
	#bubbleColorRect.size = Vector2(bubbleRect.size.x, bubbleRect.size.y)
	#bubbleColorRect.position = Vector2(bubblePosition.x, bubblePosition.y)
	#add_child(bubbleColorRect)
	
	#var leftSlice = ColorRect.new()
	#leftSlice.size = Vector2(bubble_low_x - screen_low_x, screen_high_y - screen_low_y)
	#leftSlice.position = Vector2(screen_low_x, screen_low_y)
	#add_child(leftSlice)
	
	#pick screen segment
	var segment = randi() % 4
	
	var rand_x = 0
	var rand_y = 0
	
	#pick random x and y within segment
	if (segment == 0):
		#left vertical slice
		rand_x = randi() % int(bubble_low_x - screen_low_x) + screen_low_x
		rand_y = randi() % int(screen_high_y - screen_low_y) + screen_low_y
	elif (segment == 1):
		#right vertical slice
		rand_x = randi() % int(screen_high_x - bubble_high_x) + bubble_high_x
		rand_y = randi() % int(screen_high_y - screen_low_y) + screen_low_y
	elif (segment == 2):
		#top middle section
		rand_x = randi() % int(bubble_high_x - bubble_low_x) + bubble_low_x
		rand_y = randi() % int(bubble_low_y - screen_low_y) + screen_low_y
	elif (segment == 3):
		#bottom middle section
		rand_x = randi() % int(bubble_high_x - bubble_low_x) + bubble_low_x
		rand_y = randi() % int(screen_high_y - bubble_high_y) + bubble_high_y

	var newWord = wordScene.instantiate()
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
	#elif (Globals.stage == 2):
		##delete the words
		#for word in get_tree().get_nodes_in_group("words"):
			#word.queue_free()
		##show end screen
		#$end.visible = true
		##print("ee")
		#Globals.stage = 4


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
	Globals.stage = 3
	#stop words
	$word_timer.stop()
	#$end_timer.start(Globals.endDelayTime)


func _instantiate_shader(name: String, path: String) -> void:
	var shaderScene = load(path)
	var newShader = shaderScene.instantiate()
	currentShaders[name] = newShader
	add_child(newShader)


func _free_shader(name: String) -> void:
	if currentShaders.has(name):
		currentShaders[name].queue_free()
		currentShaders.erase(name)


func _on_edge_marker_area_entered(area: Area2D) -> void:
	print(area)
	print(Globals.stage)
	if (Globals.stage == 3):
		print("home bg visible")
		homeBackground.visible = true
		homeBackground.autoscroll.x = -Globals.defaultScrollSpeed


func _on_door_area_entered(area: Area2D) -> void:
	#player has reached door of home
	if (Globals.stage == 3 && area.name == "player_area"):
		#delete the words
		for word in get_tree().get_nodes_in_group("words"):
			word.queue_free()
		#show end screen
		$end.visible = true
		#print("ee")
		Globals.stage = 4
