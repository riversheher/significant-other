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

## Item Combinations
var combinations: Dictionary = {
	"Cheese": {
		"Bloody Knife": "Cheese Slice"
	},
	"Bloody Knife": {
		"Cheese": "Cheese Slice"
	}
}

func _ready() -> void:
	#Inventory initializes with 4 slots
	inventory.resize(4)
	
func reset_inventory() -> void:
	inventory.clear()
	inventory.resize(4)
	inventory_updated.emit()
	
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
			inventory[i] = null
			
			if is_selected(to_remove["name"]):
				deselect_item()
			
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
	current_thought = thought
	thought_changed.emit()

# sets the player_node, item_two: Dictionary
func set_player_reference(player: Node):
	player_node = player
	

func select_item(item: Dictionary) -> void:
	selected_item = item

# When deselecting an item, change the cursor back
func deselect_item() -> void:
	selected_item = {}
	
func item_selected() -> bool:
	if selected_item.is_empty():
		return false
	return true
	
func is_selected(name: String) -> bool:
	if selected_item.is_empty():
		return false
	else:
		return selected_item["name"] == name
	
# compares the item being selected with the currently selected item,
# if it can be combined, remove the two items from inventory, and add
# the new combination item.
func check_combination(item_to_check: Dictionary) -> bool:
	match item_to_check["name"]:
		"Bloody Knife":
			if selected_item["name"] == "Cheese":
				remove_item(item_to_check)
				remove_item(selected_item)
				GameState.pickup_sliced_cheese()
				return true
		"Cheese":
			if selected_item["name"] == "Bloody Knife":
				remove_item(item_to_check)
				remove_item(selected_item)
				GameState.pickup_sliced_cheese()
				return true
		"Foggy Glasses":
			if selected_item["name"] == "Dirty Panties":
				remove_item(item_to_check)
				remove_item(selected_item)
				GameState.pickup_clean_glasses()
				return true
		"Dirty Panties":
			if selected_item["name"] == "Foggy Glasses":
				remove_item(item_to_check)
				remove_item(selected_item)
				GameState.pickup_clean_glasses()
				return true
		"Blurry Note":
			if selected_item["name"] == "Smelly Glasses":
				remove_item(item_to_check)
				remove_item(selected_item)
				GameState.pickup_pixel_note()
				return true
		"Smelly Glasses":
			if selected_item["name"] == "Blurry Note":
				remove_item(item_to_check)
				remove_item(selected_item)
				GameState.pickup_pixel_note()
				return true
				
	return false
