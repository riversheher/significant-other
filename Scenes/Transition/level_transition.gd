@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, FRONT, BACK }

# Add scene to be transitioned into
@export_file("*.tscn") var level
# The name of the level transition that this transition connects to.
# By default, we are using "LevelTransition", which is the name of the Scene.
@export var target_trans_area: String = "LevelTransition"

@export_category("Collision Area")
# When size is changed, the area of the rectangle will update
# This works inside the editor as well, since this is annotated as a tool script
@export_range(1,12,1,"or_greater") var size: int = 2:
	set(val):
		size = val
		_update_area()
# The side which this transition is pointing towards
@export var side: SIDE = SIDE.FRONT:
	set(val):
		side = val
		_update_area()
		
@export var snap_to_grid: bool = false
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		pass
		
	body_entered.connect(_player_entered)
	
	# set monitoring to false on intialization (turn on later)
	# monitoring = false

# _update_area updates the area of the rect in order to reflect the size input into the inspector
func _update_area() -> void:
	var new_rect: Vector2 = Vector2(48,48)
	var new_pos: Vector2 = Vector2.ZERO
	
	print("here")
	
	if side == SIDE.BACK:
		new_rect.x *= size
		new_pos.y -= 24
	elif side == SIDE.FRONT:
		new_rect.x *= size
		new_pos.y += 24
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_pos.x -= 24
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_pos.x += 24
		
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_pos
	
		
# Signal Connections
func _player_entered(_body: Node2D) -> void:
	if level == null:
		print("no level connected")
		return
	LevelManager.load_new_level(level, target_trans_area)
