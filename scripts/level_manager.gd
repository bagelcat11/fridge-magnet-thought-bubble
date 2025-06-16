extends Node2D
#on stage change to 2, spawn 'go home' word that doesn't disappear
#^where do we do this? did we want a timer?

@onready var wordScene = load("res://scenes/word.tscn")
@onready var outsideBackground = $background/outside_parallax2d
@onready var insideBackground = $background/inside_parallax2d
#@onready var homeBackground = $background/home_parallax2d
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

#SCREEN SHAKE VARS
var shakeDecayRate = 10.0 #multiplier for lerping the shake strength to zero
var shakeStrength = 0.0
var defaultShakeStrength = 15.0

#var homeBgPos = Vector2(9742, 480.02) #8192+1550

var currentShaders = {}
signal _send_player_home()
signal _end_player()

func _ready() -> void:
	$black_screen.visible = false
	$word_timer.start(1.0) #delay from opening to first word spawning
	outsideBackground.visible = false
	#homeBackground.visible = false
	insideBackground.visible = true
	insideBackground.get_node("animatedsprite").play("room")
	#outsideBackground.autoscroll.x = Globals.defaultScrollSpeed
	$player.global_position = Globals.playerRoomPos
	
	outsideBackground.get_node("home_1").visible = false
	outsideBackground.get_node("home_2").visible = false
	outsideBackground.get_node("home_1/door_area_1").monitoring = false
	outsideBackground.get_node("home_2/door_area_2").monitoring = false
	
	#NOISE
	#noise.seed = randi()
	#noise.period = 2
	
func _physics_process(delta: float) -> void:
	if (Globals.stage == 0 && shakeStrength > 0.01):
		shakeStrength = lerp(shakeStrength, 0.0, shakeDecayRate * delta)
		var shakeOffset = get_random_offset()
		self.position = shakeOffset
		insideBackground.position = shakeOffset
		#camera.offset = shake_offset

#func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	#noiseIndex += delta * speed
	#return Vector2(
		#noise.get_noise_2d(100, noiseIndex) * strength,
		#0.0
	#)
func get_random_offset() -> Vector2:
	return Vector2(
		randf() * shakeStrength * 2 - shakeStrength,
		randf() * shakeStrength * 2 - shakeStrength
	)

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
	Globals.stage = 0.5 #transition stage
	$black_screen.visible = true
	$black_screen/black_screen_animator.play("fade_in")
	$ambience.play()
	#outsideBackground.visible = true
	#insideBackground.visible = false
	#homeBackground.visible = true
	#homeBackground.autoscroll.x = Globals.defaultScrollSpeed #TODO: make home bg update speed if necessary when obj change..?
	#outsideBackground.autoscroll.x = Globals.defaultScrollSpeed
	#$player.global_position = Globals.playerDefaultPos
	#$end_timer.start(Globals.walkTime)


func _scroll_background(speed: float) -> void:
	outsideBackground.autoscroll.x = speed


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
	#free words
	for word in get_tree().get_nodes_in_group("words"):
		#currentShaders = {}
		print(word)
		#if (!word.isObject):
			#var name = word.myAttributes[0]
			#if currentShaders.has(name):
				#for shader in currentShaders[name]:
					#currentShaders[name].pop_front().queue_free()
				#currentShaders.erase(name)
		word.queue_free()
	for name in currentShaders.keys():
		print(name)
		while !currentShaders[name].is_empty():
			currentShaders[name].pop_front().queue_free()
			print(currentShaders)
		currentShaders.erase(name)
		print(currentShaders)
		print()
	$bubble.visible = false


func _instantiate_shader(name: String, path: String) -> void:
	var shaderScene = load(path)
	var newShader = shaderScene.instantiate()
	if (currentShaders.has(name)):
		currentShaders[name].append(newShader)
	else:
		currentShaders[name] = [newShader]
	add_child(newShader)
	print(currentShaders, ", added")


func _free_shader(name: String) -> void:
	if currentShaders.has(name):
		currentShaders[name].pop_front().queue_free()
		if (currentShaders[name].is_empty()):
			currentShaders.erase(name)
	print(currentShaders, ", removed")


func _on_edge_marker_area_entered(area: Area2D) -> void:
	#print(area)
	#print(Globals.stage)
	if (area.name == "background_edge_marker" && Globals.stage == 3):
		#homeBackground.autoscroll.x = 0
		#homeBackground.position = outsideBackground.position
		#homeBackground.visible = true
		#homeBackground.autoscroll.x = -Globals.defaultScrollSpeed
		outsideBackground.get_node("home_1").visible = true
		outsideBackground.get_node("home_1/door_area_1").monitoring = true
		#print("home_1 visible")
	elif (area.name == "background_edge_marker_2" && Globals.stage == 3):
		outsideBackground.get_node("home_2").visible = true
		outsideBackground.get_node("home_2/door_area_2").monitoring = true
	elif (area.name == "background_edge_marker" && Globals.stage == 1):
		outsideBackground.get_node("home_1").visible = false
		#print("home_2 visible")
	#elif (area.name == "homebg_edge_marker" && Globals.stage == 1 || Globals.stage == 2):
		##homeBackground.autoscroll.x = 0
		##homeBackground.visible = false
		#pass


func _on_door_area_entered(area: Area2D) -> void:
	#player has reached door of home
	print("door")
	if (Globals.stage == 3 && area.name == "player_area"):
		$player/forms.play("person_standing")
		outsideBackground.autoscroll.x = 0
		$black_screen/black_screen_animator.play("fade_in")
		##delete the words
		#for word in get_tree().get_nodes_in_group("words"):
			#word.queue_free()
		##show end screen
		#$end.visible = true
		#$dooropen.play()
		#$ambience.stop()
		#_end_player.emit()
		##print("ee")
		#Globals.stage = 4
		


func _shake_animation() -> void:
	shakeStrength = defaultShakeStrength
	$bedshake.play()


func _on_black_screen_animator_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "fade_in"):
		if (Globals.stage == 3):
			#delete the words
			for word in get_tree().get_nodes_in_group("words"):
				word.queue_free()
			#show end screen
			$end.visible = true
			$dooropen.play()
			$ambience.stop()
			_end_player.emit()
			#print("ee")
			Globals.stage = 4
		else:
			#timer for length of black screen
			$wait_timer.start(Globals.blackScreenTransitionTime)
			$doorclose.play()
			#clear all words from tree
			for word in get_tree().get_nodes_in_group("words"):
				word.queue_free()
			$player.global_position = Globals.playerDefaultPos
	elif (anim_name == "fade_out"):
		$black_screen.visible = false
		$word_timer.start(Globals.wordSpawnTime)
		outsideBackground.autoscroll.x = Globals.defaultScrollSpeed
		#$player.global_position = Globals.playerDefaultPos
		$player/forms.play("person_walking")
		$wait_timer.start(Globals.walkTime)


func _on_bubble__stop_word_spawning() -> void:
	$word_timer.stop()


func _on_wait_timer_timeout() -> void:
	if (Globals.stage == 1):
		Globals.stage = 2
	elif (Globals.stage == 0.5):
		Globals.stage = 1
		outsideBackground.visible = true
		insideBackground.visible = false
		outsideBackground.get_node("home_1").visible = true
		
		#homeBackground.visible = true
		#homeBackground.autoscroll.x = Globals.defaultScrollSpeed #TODO: make home bg update speed if necessary when obj change..?
		outsideBackground.autoscroll.x = 0
		$player/forms.play("person_standing")
		$black_screen/black_screen_animator.play("fade_out")


func _on_door_area_1_area_entered(area: Area2D) -> void:
	print(area)
	_on_door_area_entered(area)


func _on_door_area_2_area_entered(area: Area2D) -> void:
	print(area)
	_on_door_area_entered(area)


func _on_dooropen_finished() -> void:
	#this is such a mess.. sorry lol
	if (Globals.stage == 4):
		$doorclose.play()
