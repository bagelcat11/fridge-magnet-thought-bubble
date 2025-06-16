extends Node2D

func _ready() -> void:
	$replay_button.visible = false

#func _on_texture_button_pressed() -> void:
	#Globals.stage = 0
	#Globals.goHomeWordSpawned = false


func _on_click_finished() -> void:
	get_tree().reload_current_scene()


func _on_doorclose_finished() -> void:
	if (Globals.stage == 4):
		$replay_timer.start(1.0)


func _on_replay_timer_timeout() -> void:
	$replay_button.visible = true
	$click2.play()


func _on_replay_button_button_down() -> void:
	$click.play()
	Globals.stage = 0
	Globals.goHomeWordSpawned = false
