extends Node2D

var whoIsInBubble = []
var currentObject

var currentHeldMagnet = null

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if currentHeldMagnet != null :# and mouse is released:
		whoIsInBubble.append(currentHeldMagnet)
		currentHeldMagnet = null


func _on_word_area_area_entered(area: Area2D) -> void:
	if area.collision_layer == 2:
		currentHeldMagnet = area.get_parent()

func _on_word_area_area_exited(area: Area2D) -> void:
	if area.collision_layer == 2:
		currentHeldMagnet = null
