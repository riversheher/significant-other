@tool
class_name Level extends Node2D

@export var key_items: Array[InventoryItem]
@export var puzzles: Array[PuzzleArea]
@export var room_name: String
@export var demon_pos: Vector2

@onready var interactables_node: Node2D = $Interactables

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
		
	# Don't spawn the item if it is already picked up/used
	for item in key_items:
		if !GameState.should_item_spawn(item.item_name):
			item.set_process_mode(Node.PROCESS_MODE_DISABLED)
			item.hide()
			
	# Don't spawn puzzles if it has been solved
	for puzzle in puzzles:
		if GameState.is_puzzle_solved(puzzle.quest_name):
			puzzle.set_process_mode(Node.PROCESS_MODE_DISABLED)
			puzzle.hide()
	
	AudioPlayer._play_default_playlist()
	
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
		
	LevelManager.level_load_started.connect(_free_level)
	LevelManager.level_loaded.connect(_check_unlocked)
	
	GameState.room_entered_triggers(room_name)
	LevelManager.current_room = self

func _free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()

func _check_unlocked() -> void:
	# If not unlocked yet, stop player movement and make demon run to player.
	if !GameState.is_unlocked(self.room_name):
		PlayerManager.lock_player_movement()
		PlayerManager.add_demon_instance()
		PlayerManager.set_demon_position(demon_pos)
		PlayerManager.set_demon_parent(self)
		PlayerManager.demon.move_towards(PlayerManager.player.global_position)
		pass
