extends Node

# Inventory items
var inventory: Array = []
var player_node: Node = null

var selected_item: Dictionary = {}

@onready var inventory_slot_scene: Resource = preload("res://Scenes/GUI/Inventory/inventory_slot.tscn")

signal inventory_updated
signal inventory_duplicate
signal inventory_full

func _ready() -> void:
	#Inventory initializes with 5 slots
	inventory.resize(4)
	
# adds item to inventory
func add_item(item) -> bool:
	for i in range(inventory.size()):
		# For the purposes of this game, we are only going to use unique items, and not stackable
		# So we only need to look for equivalent names for now.
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			inventory_duplicate.emit()
			return false
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("item added", inventory)
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

# sets the player_node
func set_player_reference(player: Node):
	player_node = player
