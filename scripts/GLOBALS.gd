extends Node

signal change_form(form: Array)
var stage = 0 # 0=bedroom, 1=walking, 2=going home?
var wordTimerTime = 15.0
var wordSpawnTime = 5.0
var defaultScrollSpeed = 300.0

var objects = [
	# [ string ObjectName, float bgScrollSpeed (px/s) ]
	["person_walking", defaultScrollSpeed],
	["temp_fumo1", 0],
	["temp_fumo2", 0]
	
	#["temp_fumoball_default", false]
]

var feelings = [
	# [ string FeelingName, string pathToShader, float amountToApply ]
	["Sad", "sampleshaderpath", 0.3]
]

var move_words = [
	["get up"],
	["move"],
	["go"]
]
