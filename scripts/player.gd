extends Node2D

func _ready() -> void:
	Globals.change_form.connect(change)
	$forms.play("temp_fumoball_default")
	
	#print("is connected: ", Globals.is_connected("change_form", change))
	#print("connections: ", Globals.change_form.get_connections())

func _physics_process(delta: float) -> void:
	pass

func change(form: Array):
	#print("trying to play ", form[0])
	$forms.play(form[0])
	#print("playing ", $forms.animation)
