@tool
class_name InventoryItem extends Node2D

@export var item_description: String = ""
@export var item_name: String = ""
@export var item_effect: String = ""
@export var pickup_message: String = ""
@export var item_texture: Texture
@export var item_sound: AudioStream

@export_range(0,2,0.1) var collision_size: float = 1:
	set(val):
		collision_size = val
		_update_area()
		
var scene_path: String = "res://Scenes/InventoryItem/inventory_item.gd"

@onready var icon_sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var player_in_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		icon_sprite.texture = item_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Show updated sprite in editor
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("trying to interact")
		pickup_item()

func pickup_item() -> void:
	var item = {
		# Amount of the item that will be added to inventory.  For purpose of this game, doesn't matter
		"quantity": 1,
		"name": item_name,
		"effect": item_effect,
		"description": item_description,
		"texture": item_texture,
		"scene_path": scene_path,
	}
	if InventoryManager.player_node:
		InventoryManager.add_item(item)
		InventoryManager.change_thought(pickup_message)
		
		GameState.pickup_item(item_name)
		
		if item_sound != null:
			AudioPlayer.play_FX(item_sound)
		
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_sprite.visible = true
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_sprite.visible = false
		player_in_range = false
		
func _update_area() -> void:
	if collision_shape == null:
		collision_shape = get_node("Area2D/CollisionShape2D")
	collision_shape.set_scale(Vector2(collision_size, collision_size))
