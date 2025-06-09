extends Node

signal change_form(form: Array)
var stage = 0 # 0=bedroom, 1=walking, 2=going home?
var wordTimerTime = 15.0
var wordSpawnTime = 5.0
var defaultScrollSpeed = 300.0
var walkTime = 10.0 #in seconds (will be longer, short for testing)
var endDelayTime = 3.0 #in seconds (delay after go home before game ends)
var goHomeWordSpawned = false

var default_obj = ["person_walking", defaultScrollSpeed, "Person"]

var objects = [
	# [ string ObjectName, float bgScrollSpeed (px/s), string DisplayName]
	#["temp_fumo1", -100, ""],
	#["temp_fumo2", -200, ""],
	["alien", defaultScrollSpeed, "Alien"],
	["apple", defaultScrollSpeed, "Apple"],
	["bed", defaultScrollSpeed, "Bed"],
	["book", defaultScrollSpeed, "Book"],
	["boots", defaultScrollSpeed, "Boots"],
	["bow", defaultScrollSpeed, "Bow"],
	["bowling", defaultScrollSpeed, "Bowling"],
	["boxers", defaultScrollSpeed, "Boxers"],
	["chair", defaultScrollSpeed, "Chair"],
	["earth", defaultScrollSpeed, "Earth"],
	["flower", defaultScrollSpeed, "Flower"],
	["frog_table", defaultScrollSpeed, "Table"],
	["hockey_stick", defaultScrollSpeed, "Hockey"],
	["homework", defaultScrollSpeed, "Homework"],
	["inchworm", defaultScrollSpeed, "Inchworm"],
	["meat", defaultScrollSpeed, "Dinner"],
	["mirror", defaultScrollSpeed, "Mirror"],
	["mouse_bike", defaultScrollSpeed, "Bike"],
	["propeller_hat", defaultScrollSpeed, "Hat"],
	["undergarments", defaultScrollSpeed, "Underwear"]
	
	#["temp_fumoball_default", false]
]

var feelings = [
	# [ string FeelingName, string pathToShader, float amountToApply ]
	["Soggy", "res://scenes/shader_scenes/rain_shader.tscn", 1.0],
	["Spooky", "res://scenes/shader_scenes/fog_shader.tscn", 1.0],
	["Crunchy", "res://scenes/shader_scenes/crunchy_shader.tscn", 1.0],
	["Trapped", "res://scenes/shader_scenes/trapped_shader.tscn", 1.0],
	["Woozy", "res://scenes/shader_scenes/woozy_shader.tscn", 1.0],
	["Purpley swirly", "res://scenes/shader_scenes/purple_swirl_shader.tscn", 1.0],
	["Reeling", "res://scenes/shader_scenes/chromatic_aberration_shader.tscn", 1.0]
]

var move_words = [
	["Get up"],
	["Move"],
	["Go"]
]

var go_home_word = ["Go home"]
