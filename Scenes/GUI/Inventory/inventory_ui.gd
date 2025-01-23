extends Control

@onready var h_container: HBoxContainer = $HContainer

func _ready() -> void:
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

# update inventory UI
func _on_inventory_updated() -> void:
	clear_grid_container()
	# add a slot per item
	for item in InventoryManager.inventory:
		var slot: InventorySlot = InventoryManager.inventory_slot_scene.instantiate()
		h_container.add_child(slot)
		if item != null :
			slot.set_item(item)
		else:
			slot.set_empty()
	
# Frees up inventory
func clear_grid_container() -> void:
	while h_container.get_child_count() > 0:
		var child: Node = h_container.get_child(0)
		h_container.remove_child(child)
		child.queue_free()
