@tool
class_name PuzzleArea extends Area2D

@export_category("Collision Area")
@export_range(1,12,1,"or_greater") var y_size: int = 2:
	set(val):
		y_size = val
		_update_area()
		
@export_range(1,12,1,"or_greater") var x_size: int = 2:
	set(val):
		x_size = val
		_update_area()

@onready var collision_shape: CollisionShape2D = $InteractionArea

@export_category("Quest Info")
@export var quest_name: String = ""
@export var required_item: String = ""
@export var message_fail: String = ""
@export var message_success: String = ""

# Game Variables
var player_in_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		pass

# _update_area updates the area of the rect in order to reflect the size input into the inspector
func _update_area() -> void:
	var new_rect: Vector2 = Vector2(24,24)

	if collision_shape == null:
		collision_shape = get_node("InteractionArea")
		
	new_rect.x *= x_size
	new_rect.y *= y_size
		
	collision_shape.shape.size = new_rect
	
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		# Check if player has correct item selected
		if required_item == "" or InventoryManager.is_selected(required_item):
			complete_puzzle()
			self.queue_free()
		# Check if player has correct item
		elif InventoryManager.has_item(required_item):
			InventoryManager.change_thought(message_success)
			AudioPlayer.play_thinking_sound(-5)
		else:
			InventoryManager.change_thought(message_fail)
			AudioPlayer.play_thinking_sound(-5)
			


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_sprite.visible = true
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_sprite.visible = false
		player_in_range = false
		
# Complete the puzzle and update game state
func complete_puzzle() -> void:
	GameState.mark_puzzle_solved(quest_name)
