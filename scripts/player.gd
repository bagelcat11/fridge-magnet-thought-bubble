extends Node2D

signal _start_stage_1()

func _ready() -> void:
	Globals.change_form.connect(change)
	$forms.play("person_lying")
	
	#print("is connected: ", Globals.is_connected("change_form", change))
	#print("connections: ", Globals.change_form.get_connections())

func _physics_process(delta: float) -> void:
	pass

func change(form: Array):
	#print("trying to play ", form[0])
	$forms.play(form[0])
	#print("playing ", $forms.animation)


func _get_up() -> void:
	$forms.play("person_getting_up")


func _on_forms_animation_finished() -> void:
	if ($forms.animation == "person_getting_up"):
		$forms.play("person_walking")
		_start_stage_1.emit()
		#print("start stage 1 signal emitted")
		


func _on_main_level__send_player_home() -> void:
	$forms.flip_h = true
	$forms.play("person_walking")
	#print("going home")
