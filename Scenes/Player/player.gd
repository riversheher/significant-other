class_name Player extends CharacterBody2D

@export var WALK_SPEED: float = 72
@export var RUN_SPEED: float = 144
@export var state: String = "idle"
@export var direction: String = "front"

# pressed_keys keeps track of which keys are currently pressed, and is used to determine
# the player's state.
# The keys are the names of the actions, and the values are the priority of the actions based on
# the order they were pressed.
var pressed_keys: Dictionary = {}

func _ready() -> void:
	$AnimatedSprite2D.animation = "idle_front"
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()

func _process(delta: float) -> void:

	var is_running: bool = Input.is_action_pressed("run")
	
	# Set the state of the character based on which key has just been pressed
	if Input.is_action_just_pressed("back"):
		add_direction("back", is_running)
	elif Input.is_action_just_pressed("front"):
		add_direction("front", is_running)
	elif Input.is_action_just_pressed("left"):
		add_direction("left", is_running)
	elif Input.is_action_just_pressed("right"):
		add_direction("right", is_running)

	# If a key has been released, remove it from the pressed_keys dictionary
	# If there are no keys left in the dictionary, set the state to idle in the
	# direction based on the last key that was released
	if Input.is_action_just_released("back"):
		remove_direction("back")
	if Input.is_action_just_released("front"):
		remove_direction("front")
	if Input.is_action_just_released("left"):
		remove_direction("left")
	if Input.is_action_just_released("right"):
		remove_direction("right")

	# change state to run or walk if play is already moving
	if state == "walk" and is_running:
		state = "run"
	elif state == "run" and not is_running:
		state = "walk"


	$AnimatedSprite2D.animation = state + "_" + direction
	$AnimatedSprite2D.play()

# Change the direction of the player based on the new action
# Uses the pressed_keys dictionary to determine the new state
func add_direction(new_action: String, is_running: bool) -> void:
	match new_action:
		"back":
			pressed_keys[new_action] = pressed_keys.size()
			direction = new_action
		"front":
			pressed_keys[new_action] = pressed_keys.size()
			direction = new_action
		"left":
			pressed_keys[new_action] = pressed_keys.size()
			direction = new_action
		"right":
			pressed_keys[new_action] = pressed_keys.size()
			direction = new_action
	match is_running:
		true:
			state = "run"
		false:
			state = "walk"

# Remove the movement of the player based on the action that has been released
# If there are no keys left in the dictionary, set the state to idle in the
# direction based on the last key that was released
func remove_direction(action: String) -> void:
	pressed_keys.erase(action)
	if pressed_keys.size() == 0:
		state = "idle"
	else:
		# Check what other keys are pressed and what priority they have
		# Set the state based on the highest priority key
		var highest_priority: int = -1
		var highest_priority_action: String = ""
		for key in pressed_keys.keys():
			if pressed_keys[key] > highest_priority:
				highest_priority = pressed_keys[key]
				highest_priority_action = key
		direction = highest_priority_action

# process_movement moves the player based on the current state and direction
func process_movement() -> void:
	var movement: Vector2 = Vector2.ZERO
	if (state == "idle"):
		velocity = Vector2.ZERO
	else:
		match direction:
			"back":
				movement.y = -1
			"front":
				movement.y = 1
			"left":
				movement.x = -1
			"right":
				movement.x = 1
		if state == "run":
			velocity = movement * RUN_SPEED
		else:
			velocity = movement * WALK_SPEED
