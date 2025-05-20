extends Node

signal change_form(form: Array)

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
