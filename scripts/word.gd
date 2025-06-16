extends Node2D

# implicit opposite: isFeeling
var isObject
var chanceForObject = 0.1
var rng = RandomNumberGenerator.new()

var myAttributes = []

var timeSinceLastInteract = 0.0
var hasMouse = false
var isPickedUp = false
var isInBubble = false
var pickupOffset = Vector2.ZERO
var sizeScaleWhenPickedUp = 1.2
var isGoHomeWord = false

@onready var viewportSize = get_viewport().get_visible_rect().size

func _ready() -> void:
	var c = rng.randf()
	if (Globals.stage == 0):
		c = rng.randi_range(0, Globals.move_words.size() - 1)
		myAttributes = Globals.move_words[c]
	elif (Globals.stage == 2 && !Globals.goHomeWordSpawned):
		Globals.goHomeWordSpawned = true
		myAttributes = Globals.go_home_word
		isGoHomeWord = true
	elif (Globals.stage == 1 || Globals.stage == 2):
		$Timer.start(Globals.wordTimerTime)
		if c <= chanceForObject:
			isObject = true
		else:
			isObject = false

		if isObject:
			# get random object from list
			c = rng.randi_range(0, Globals.objects.size() - 1)
			myAttributes = Globals.objects[c]
		else:
			# get random feeling
			c = rng.randi_range(0, Globals.feelings.size() - 1)
			myAttributes = Globals.feelings[c]
	if (myAttributes.size() > 0):
		if isObject:
			$name.text = myAttributes[2]
		else:
			$name.text = myAttributes[0]
	
	spawn_in_anim()
	$spawn.play()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and hasMouse:
		isPickedUp = !isPickedUp
		#print("picked up: ", isPickedUp)
		
		if isPickedUp:
			# drop shadow also??
			pickupOffset = get_global_position() - get_global_mouse_position()
			self.scale = Vector2(sizeScaleWhenPickedUp, sizeScaleWhenPickedUp)
			$pickup.play()
			if (Globals.stage == 1 || (Globals.stage == 2 && !isGoHomeWord)):
				$Timer.stop()
		else:
			self.scale = Vector2(1, 1)
			$putdown.play()
			if (!isInBubble && (Globals.stage == 1 || (Globals.stage == 2 && !isGoHomeWord))):
				$Timer.start(Globals.wordTimerTime)

func _physics_process(delta: float) -> void:
	if isPickedUp:
		var mousePosition = get_global_mouse_position()
		if (mousePosition.x > viewportSize.x || mousePosition.y > viewportSize.y || mousePosition.x < 0 || mousePosition.y < 0):
			#if mouse outside of viewport
			isPickedUp = false
			$putdown.play()
		else:
			global_position = mousePosition + pickupOffset


func spawn_in_anim():
	# fade in
	pass

func fade_out_anim():
	# fade out; call this after left outside bubble for some time
	pass


func _on_fridge_magnet_mouse_entered() -> void:
	hasMouse = true
	#print("hasMouse :3")

func _on_fridge_magnet_mouse_exited() -> void:
	#if (mouseIsOnScreen):
	hasMouse = false
	#print("no more has mouse :/")


func _on_timer_timeout() -> void:
	#delete word
	self.queue_free()
