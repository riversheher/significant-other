extends Node

## Level Loading
# emitted when level begins loading
signal level_load_started
# emitted when level is finished loading
signal level_loaded

signal demon_collision

# The target transition to play when transitioning between scenes
var target_trans: String
# Where to place the player in the new scene
var player_pos_offset: Vector2

var current_room: Level

## Camera Settings
signal map_bounds_changed(bounds: Dictionary)
# A dictionary of String: Vector2, which stores the corner of the bounds.
# "top left" and "bottom right" are expected
var curr_map_bounds: Dictionary

func _ready() -> void:
	demon_collision.connect(to_game_over)

func change_map_bounds(bounds: Dictionary) -> void:
	curr_map_bounds = bounds
	map_bounds_changed.emit(bounds)

	
func place_player_on_trans() -> void:
	var trans_area: LevelTransition = get_tree().get_current_scene().get_node(target_trans)
	# Offset to place player from transition area
	var offset: Vector2 = Vector2.ZERO
	
	if trans_area.side == LevelTransition.SIDE.BACK:
		offset.y += 48
	elif trans_area.side == LevelTransition.SIDE.FRONT:
		offset.y -= 48
	elif trans_area.side == LevelTransition.SIDE.LEFT:
		offset.x += 48
	elif trans_area.side == LevelTransition.SIDE.RIGHT:
		offset.x -= 48
		
	PlayerManager.set_player_position(trans_area.global_position + offset)
	PlayerManager.reset_player_state()
	
func load_new_level(
	level_path: String, 
	t_trans: String,
) -> void:
	
	get_tree().paused = true
	target_trans = t_trans
	
	AudioPlayer.play_FX(AudioPlayer.door_open, -2.0)
	await SceneTransition.transition_out("fade_out")
	
	level_load_started.emit()
	
	# waits for the next process frame to complete
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	
	await get_tree().process_frame
	# place player right below/above/beside target transition area
	place_player_on_trans()
	
	AudioPlayer.play_FX(AudioPlayer.door_close, -2.0)
	await SceneTransition.transition_in("fade_in")
	level_loaded.emit()
	
	get_tree().paused = false
	
func to_game_over() -> void:
	get_tree().paused = true
	
	AudioPlayer.play_FX(AudioPlayer.death_sound, -2.0)
	await SceneTransition.transition_out("fade_out")
	level_load_started.emit()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/GUI/GameOver.tscn")
	
	await get_tree().process_frame
	await SceneTransition.transition_in("fade_in")
	
	get_tree().paused = false
	
func to_retry() -> void:
	get_tree().paused = true
	
	PlayerManager.player_spawned = false
	PlayerManager.allow_player_movement()
	
	GameState.reset_game()
	
	await SceneTransition.transition_out("fade_out")
	get_tree().change_scene_to_file("res://Scenes/Levels/BedroomLVL/sandbox.tscn")
	
	await get_tree().process_frame
	InventoryManager.reset_inventory()
	InventoryManager.change_thought("I need to get out of here...")
	await SceneTransition.transition_in("fade_in")
	
	get_tree().paused = false
	
func to_credits() -> void:
	get_tree().paused = true
	
	await SceneTransition.transition_out("fade_out")
	level_load_started.emit()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/GUI/credits.tscn")
	
	await get_tree().process_frame
	await SceneTransition.transition_in("fade_in")
	
	get_tree().paused = false
