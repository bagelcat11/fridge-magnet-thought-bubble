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
	print("changing to", form)
	$forms.play(form[0])
	$transform.play()
	$movement_sfx.stream = form[3]
	$movement_sfx.play(0)
	#print("playing ", $forms.animation)
	if $forms.get_sprite_frames().get_frame_count($forms.animation) == 1:
		$hop_animator.play("hop")
	else:
		$hop_animator.stop()


func _get_up() -> void:
	$forms.play("person_getting_up")


func _on_forms_animation_finished() -> void:
	if ($forms.animation == "person_getting_up"):
		change(Globals.default_obj)
		_start_stage_1.emit()
		#print("start stage 1 signal emitted")
		


func _on_main_level__send_player_home() -> void:
	$forms.flip_h = true
	change(Globals.default_obj)
	#$forms.play("person_walking")
	#print("going home")
	self.position.x -= 100


func _end_player() -> void:
	$movement_sfx.stop()
