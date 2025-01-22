extends Node

## Level Loading
# emitted when level begins loading
signal level_load_started
# emitted when level is finished loading
signal level_loaded

# The target transition to play when transitioning between scenes
var target_trans: String
# Where to place the player in the new scene
var player_pos_offset: Vector2

## Camera Settings
signal map_bounds_changed(bounds: Dictionary)
# A dictionary of String: Vector2, which stores the corner of the bounds.
# "top left" and "bottom right" are expected
var curr_map_bounds: Dictionary

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
	
	await SceneTransition.transition_out("fade_out")
	
	level_load_started.emit()
	
	# waits for the next process frame to complete
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	
	await get_tree().process_frame
	# place player right below/above/beside target transition area
	place_player_on_trans()
	
	await SceneTransition.transition_in("fade_in")
	level_loaded.emit()
	
	get_tree().paused = false
	
	pass
