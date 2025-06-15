extends Node

signal change_form(form: Array)
var stage = 0 # 0=bedroom, 1=walking, 2=going home Appears, 3=walking home
var wordTimerTime = 15.0
var wordSpawnTime = 5.0
var defaultScrollSpeed = 300.0
var walkTime = 20.0 #in seconds, time before 'go home' spawns (will be longer, short for testing)
var blackScreenTransitionTime = 1.0
#var endDelayTime = 100.0 #in seconds (delay after go home before game ends)
var goHomeWordSpawned = false
var word_w = 124
var word_h = 36 #im so sorry but word size is being a PAIN im just gonna put this here
var playerRoomPos = Vector2(953.0, 552.0)
var playerDefaultPos = Vector2(1001.0, 722.0)

# sound resources ourgh
var movement_alien = preload("res://assets/sfx/alien.wav")
var movement_bike = preload("res://assets/sfx/bike.wav")
var movement_metal = preload("res://assets/sfx/metal.wav")
var movement_step_heavy = preload("res://assets/sfx/step_heavy.wav")
var movement_step_medium = preload("res://assets/sfx/step_medium.wav")
var movement_step_light = preload("res://assets/sfx/step_light.wav")
var movement_worm = preload("res://assets/sfx/worm.wav")

var default_obj = ["person_walking", defaultScrollSpeed, "Person", movement_step_medium]

var objects = [
	# [ string ObjectName, float bgScrollSpeed (px/s), string DisplayName, string SFX_Path]
	#["temp_fumo1", -100, ""],
	#["temp_fumo2", -200, ""],
	["alien", defaultScrollSpeed, "Alien", movement_alien],
	["apple", defaultScrollSpeed, "Apple", movement_step_light],
	["bed", defaultScrollSpeed, "Bed", movement_metal],
	["book", defaultScrollSpeed, "Book", movement_step_light],
	["boots", defaultScrollSpeed, "Boots", movement_step_medium],
	["bow", defaultScrollSpeed, "Bow", movement_step_light],
	["bowling", defaultScrollSpeed, "Bowling", movement_step_heavy],
	["boxers", defaultScrollSpeed, "Boxers", movement_step_light],
	["chair", defaultScrollSpeed, "Chair", movement_step_medium],
	["earth", defaultScrollSpeed, "Earth", movement_step_heavy],
	["flower", defaultScrollSpeed, "Flower", movement_step_heavy],
	["frog_table", defaultScrollSpeed, "Table", movement_step_heavy],
	["hockey_stick", defaultScrollSpeed, "Hockey", movement_step_medium],
	["homework", defaultScrollSpeed, "Homework", movement_step_light],
	["inchworm", defaultScrollSpeed, "Inchworm", movement_worm],
	["meat", defaultScrollSpeed, "Dinner", movement_step_light],
	["mirror", defaultScrollSpeed, "Mirror", movement_metal],
	["mouse_bike", defaultScrollSpeed, "Bike", movement_bike],
	["propeller_hat", defaultScrollSpeed, "Hat", movement_step_light],
	["undergarments", defaultScrollSpeed, "Underwear", movement_step_light],
	["cats", defaultScrollSpeed, "Cats", movement_bike],
	["horse", 600.0, "Horse", movement_step_heavy]
	
	#["temp_fumoball_default", false]
]

var feelings = [
	# [ string FeelingName, string pathToShader, float amountToApply ]
	["Soggy", "res://scenes/shader_scenes/rain_shader.tscn", 1.0],
	["Uneasy", "res://scenes/shader_scenes/fog_shader.tscn", 1.0],
	["Crunchy", "res://scenes/shader_scenes/crunchy_shader.tscn", 1.0],
	["Trapped", "res://scenes/shader_scenes/trapped_shader.tscn", 1.0],
	["Woozy", "res://scenes/shader_scenes/woozy_shader.tscn", 1.0],
	["Spiraling", "res://scenes/shader_scenes/purple_swirl_shader.tscn", 1.0],
	["Reeling", "res://scenes/shader_scenes/chromatic_aberration_shader.tscn", 1.0]
]

var move_words = [
	["Get up"],
	["Move"],
	["Go!"]
]

var go_home_word = ["Go home..."]
