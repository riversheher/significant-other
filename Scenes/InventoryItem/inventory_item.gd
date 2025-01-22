@tool
extends Node2D

@export var item_type: String = ""
@export var item_name: String = ""
@export var item_effect: String = ""
@export var item_texture: Texture
var scene_path: String = "res://Scenes/InventoryItem/inventory_item.gd"

@onready var icon_sprite = $Sprite2D

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
		"type": item_type,
		"name": item_name,
		"effect": item_effect,
		"texture": item_texture,
		"scene_path": scene_path
	}
	if InventoryManager.player_node:
		InventoryManager.add_item(item)
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_ui.visible = true
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_ui.visible = false
		player_in_range = false
