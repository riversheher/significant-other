extends Node

# Inventory items
var inventory: Array = []
var player_node: Node = null

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
func remove_item(item: Dictionary) -> bool:
	var removed = false
	
	inventory_updated.emit()
	return removed

# sets the player_node
func set_player_reference(player: Node):
	player_node = player
