class_name Level extends Node2D

@onready var interactables_node: Node2D = $Interactables

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer._play_default_playlist()
	
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)

func _free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()
