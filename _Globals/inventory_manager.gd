extends Node

# Inventory items
var inventory: Array = []
var player_node: Node = null

var selected_item: Dictionary = {}

@onready var inventory_slot_scene: Resource = preload("res://Scenes/GUI/Inventory/inventory_slot.tscn")

signal inventory_updated
signal inventory_duplicate
signal inventory_full

## Thought Stuff
var current_thought: String = ""
signal thought_changed

func _ready() -> void:
	#Inventory initializes with 4 slots
	inventory.resize(4)
	
# adds item to inventory
func add_item(item) -> bool:
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
		
	inventory_full.emit()
	return false

# removes item to inventory
func remove_item(to_remove: Dictionary) -> bool:
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == to_remove["name"]:
			inventory.remove_at(i)
			inventory_updated.emit()
			return true
	
	return false
	
# checks if an item name exists in the inventory
func has_item(to_check: String) -> bool:
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == to_check:
			return true
			
	return false
	
# Changes the player's thought
func change_thought(thought: String) -> void:
	print("player is thinking")
	current_thought = thought
	thought_changed.emit()

# sets the player_node
func set_player_reference(player: Node):
	player_node = player
