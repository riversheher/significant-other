extends Node

var unlocked_rooms = {
	"bedroom": true,
	"livingroom": false, 
	"washroom": false
}
var solved_puzzles = {
	"bedroom window": false, 
	"washroom cheese": false, 
	"doors": false,
	"note": false
}

var key_items = {
	"Cheese": true,
	"River's Key": true,
	"Bloody Knife": true,
	"Foggy Glasses": true,
	"Dirty Panties": true,
	"Blurry Note": true
}

var combinations = {
	"Bloody Knife": "Cheese",
	"Cheese": "Bloody Knife"
}

var doors_locked: int = 0

var timer: Timer

var key_sound: AudioStream = preload("res://Assets/SFX/keys jingling - single.wav")
var running_sound: AudioStream = preload("res://Assets/SFX/running.wav")
var slice_cheese_icon: Texture = preload("res://Assets/Items/white_cheese_piece.png")
var pixel_note_icon: Texture = preload("res://Assets/Items/06.png")
var clean_glasses_icon: Texture = preload("res://Assets/Items/glasses_002.png")

func reset_game() -> void:
	reset_self()

# resets all game state (purpose is to be used on game over)
func reset_self() -> void:
	key_items = {
		"Cheese": true,
		"River's Key": true,
		"Bloody Knife": true,
		"Foggy Glasses": true,
		"Dirty Panties": true,
		"Blurry Note": true
	}
	
	solved_puzzles = {
		"bedroom window": false, 
		"washroom cheese": false, 
		"doors": false
	}
	
	unlocked_rooms = {
		"bedroom": true,
		"livingroom": false, 
		"washroom": false
	}
	
	doors_locked = 0
	
	reset_timer()
	
func reset_timer() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = 30
	timer.timeout.connect(_fail_doors_locked)

func unlock_room(room_name):
	unlocked_rooms[room_name] = true
	
func is_unlocked(room_name: String) -> bool:
	if unlocked_rooms.has(room_name):
		return unlocked_rooms[room_name]
	return false
	
func mark_puzzle_solved(puzzle_name):
	solved_puzzles[puzzle_name] = true
	
	# Additional logic for what gets unlocked and what gets triggered when the
	# puzzle is solved.
	match puzzle_name:
		"bedroom window":
			_solve_bedroom_window()
		"washroom cheese":
			_solve_washroom_cheese()
		"doors":
			await AudioPlayer.play_FX(AudioPlayer.door_lock)
			doors_locked += 1
			if doors_locked == 1:
				InventoryManager.change_thought("That's one locked, two more to go...")
				AudioPlayer.play_FX(AudioPlayer.light_cough)
			if doors_locked == 2:
				InventoryManager.change_thought("That's two locked, one more to go...")
				AudioPlayer.play_FX(AudioPlayer.light_cough)
			if doors_locked == 3:
				_solve_doors_locked()
		"note":
			_solve_note()
			
			
	
func pickup_item(item_name: String) -> void:
	key_items[item_name] = false
	
func should_item_spawn(item_name: String) -> bool:
	if key_items.has(item_name):
		return key_items[item_name]
		
	return false
	
# Handles logic for game state when entering a new room
func room_entered_triggers(room_name: String):
	# If just entered living room and you didn't solve the doors puzzle, start timer
	if room_name == "livingroom" and !solved_puzzles["doors"] and solved_puzzles["bedroom window"]:
		if timer == null:
			reset_timer()
		add_child(timer)
		InventoryManager.change_thought("I have to make sure River can't get back in!  I need to lock the doors.")
		AudioPlayer.play_FX(AudioPlayer.light_cough)
		
		print("timer started 20 seconds")
	
func is_puzzle_solved(puzzle_name: String) -> bool:
	if solved_puzzles.has(puzzle_name):
		return solved_puzzles[puzzle_name]
		
	return false
	
func _solve_bedroom_window():
	unlocked_rooms["livingroom"] = true
	var item = {
		"name": "River's Key"
	}
	InventoryManager.remove_item(item)
	await AudioPlayer.play_FX(key_sound)
	AudioPlayer.play_FX(running_sound)
	InventoryManager.change_thought("Sounds like River is distracted... Let's hurry!")
	
func _solve_washroom_cheese():
	unlocked_rooms["washroom"] = true
	var item = {
		"name": "Sliced Cheese"
	}
	InventoryManager.remove_item(item)
	await AudioPlayer.play_FX(running_sound)
	InventoryManager.change_thought("Sounds like River is scurrying away!")

# Once the timer ends, the living roomitem_texture is no longer safe
# If the player is still in the living room, stop them from moving and river comes to kill
func _fail_doors_locked():
	print("failed to lock doors")
	unlocked_rooms["livingroom"] = false
	
	if LevelManager.current_room != null:
		LevelManager.current_room._check_unlocked()
	
func _solve_doors_locked():
	timer.stop()
	timer.queue_free()
	InventoryManager.change_thought("River shouldn't be able to get back in now that all the doors are locked.")
	AudioPlayer.play_FX(AudioPlayer.light_cough)
	
func _solve_note():
	solved_puzzles["note"] = true
	
	AudioPlayer.play_thinking_sound()
	
	var server = HttpServer.new()
	server.register_router("/", LoveRouter.new())
	add_child(server)
	server.enable_cors(["http://localhost:8060"])
	server.start()
	
func pickup_sliced_cheese() -> void:
	var sliced_cheese: InventoryItem = InventoryItem.new()
	sliced_cheese.item_name = "Sliced Cheese"
	sliced_cheese.item_description = "It's so small and stinky... The smell River hates most."
	sliced_cheese.pickup_message = "I hope I can use this to scare River..."
	sliced_cheese.item_texture = slice_cheese_icon
	sliced_cheese.item_sound = AudioPlayer.knife_sound
	
	sliced_cheese.pickup_item()
	
func pickup_clean_glasses() -> void:
	var glasses: InventoryItem = InventoryItem.new()
	glasses.item_name = "Smelly Glasses"
	glasses.item_description = "The lenses have some oily smears on it, but you can see through them."
	glasses.pickup_message = "I guess this will have to do. I should be able to read now."
	glasses.item_texture = clean_glasses_icon
	glasses.item_sound = AudioPlayer.glasses_sound
	
	glasses.pickup_item()
	
func pickup_pixel_note() -> void:
	var pixelated_note: InventoryItem = InventoryItem.new()
	pixelated_note.item_name = "Pixelated Note"
	pixelated_note.item_description = "You can see the note clearly, but it's all pixels!"
	pixelated_note.pickup_message = "Maybe I can read this better at my desk?"
	pixelated_note.item_texture = pixel_note_icon
	pixelated_note.item_sound = AudioPlayer.note_sound
	
	pixelated_note.pickup_item()
	
func to_credits() -> void:
	pass
