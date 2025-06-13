extends Node2D

var whoIsInBubble = []
#var currentObject
var formStack = []

var default_form = Globals.default_obj

signal _get_up()
signal _scroll_background(speed: float)
signal _go_home()
signal _instantiate_shader(name: String, path: String)
signal _free_shader(name: String)

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
		mag.isInBubble = true
		#print(mag.myAttributes)
		#mag.get_node("Timer").stop()
		#print("currently have: " + str(whoIsInBubble))
		if (Globals.stage == 0):
			#do funny move word things in here:
			#TODO: play animation when word is put in bubble (shake anim or smth)
			#if all move words are in bubble (TODO: make words not spawn multiple times)
			#print(whoIsInBubble)
			if (whoIsInBubble.size() == Globals.move_words.size()):
				#get up
				_get_up.emit()
				#clear all words from bubble
				whoIsInBubble = []
				#clear all words from tree
				for word in get_tree().get_nodes_in_group("words"):
					word.queue_free()
		elif (Globals.stage == 1 || Globals.stage == 2):
			if mag.isGoHomeWord:
				_go_home.emit()
				#print("go home signal emitted")
				return
			if mag.isObject:
				formStack.append(mag.myAttributes)

				if formStack.size() > 0:
					#print("going to emit: ", formStack[-1], " of type ", typeof(formStack[-1]))
					Globals.change_form.emit(formStack[-1])
					_scroll_background.emit(formStack[-1][1]) #change bc scroll speed
					#Globals.emit_signal("change_form", formStack[-1])
					#print("changing form to ", formStack[-1])
					#print("THIS IS AFTER THE THING IS EMITTED")
				else:	
					Globals.change_form.emit(default_form)
					_scroll_background.emit(default_form[1]) #change bc scroll speed
					#print("changing form to ", default_form)
			else:
				_instantiate_shader.emit(mag.myAttributes[0], mag.myAttributes[1])

func _on_word_area_area_exited(area: Area2D) -> void:
	if area.collision_layer == 2:
		var mag = area.get_parent()
		whoIsInBubble.erase(mag)
		mag.isInBubble = false
		#print("currently have: " + str(whoIsInBubble))
		if (Globals.stage == 1 || Globals.stage == 2):
			if mag.isObject:
				formStack.erase(mag.myAttributes)

				if formStack.size() > 0:
					Globals.change_form.emit(formStack[-1])
					_scroll_background.emit(formStack[-1][1]) #change bc scroll speed
					#print("changing form to ", formStack[-1])
				else:
					Globals.change_form.emit(default_form)
					_scroll_background.emit(default_form[1]) #change bc scroll speed
					#print("changing form to ", default_form)
			else:
				_free_shader.emit(mag.myAttributes[0])
				
