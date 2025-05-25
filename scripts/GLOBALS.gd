extends Node

signal change_form(form: Array)
var stage = 1 # 0=bedroom, 1=walking, 2=going home?
var wordTimerTime = 15.0
var wordSpawnTime = 5.0

var objects = [
	# [ string ObjectName, bool scrollsBG ]
	["temp_fumo1", false],
	["temp_fumo2", false]
	#["temp_fumoball_default", false]
]

var feelings = [
	# [ string FeelingName, string pathToShader, float amountToApply ]
	["Sad", "sampleshaderpath", 0.3]
]
