extends Node2D

var whoIsInBubble = []
#var currentObject
var formStack = []

var default_form = ["temp_fumoball_default", false]

#var currentHeldMagnet = null

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#if currentHeldMagnet != null :# and mouse is released:
		#currentHeldMagnet = null
	pass


func _on_word_area_area_entered(area: Area2D) -> void:
	if area.collision_layer == 2:
		var mag = area.get_parent()
		whoIsInBubble.append(mag)
		#print("currently have: " + str(whoIsInBubble))
		if mag.isObject:
			formStack.append(mag.myAttributes)

		if formStack.size() > 0:
			#print("going to emit: ", formStack[-1], " of type ", typeof(formStack[-1]))
			Globals.change_form.emit(formStack[-1])
			#Globals.emit_signal("change_form", formStack[-1])
			#print("changing form to ", formStack[-1])
			#print("THIS IS AFTER THE THING IS EMITTED")
		else:	
			Globals.change_form.emit(default_form)
			#print("changing form to ", default_form)

func _on_word_area_area_exited(area: Area2D) -> void:
	if area.collision_layer == 2:
		var mag = area.get_parent()
		whoIsInBubble.erase(mag)
		#print("currently have: " + str(whoIsInBubble))
		if mag.isObject:
			formStack.erase(mag.myAttributes)

		if formStack.size() > 0:
			Globals.change_form.emit(formStack[-1])
			#print("changing form to ", formStack[-1])
		else:
			Globals.change_form.emit(default_form)
			#print("changing form to ", default_form)
