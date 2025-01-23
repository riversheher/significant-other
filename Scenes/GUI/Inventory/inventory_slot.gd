class_name InventorySlot extends Control

@onready var ItemName: Label = $DetailsPanel/ItemName
@onready var ItemDescription: Label = $DetailsPanel/ItemDescription
@onready var ItemIcon: Sprite2D = $ItemPanel/ItemIcon
@onready var DetailsPanel: Control = $DetailsPanel
@onready var button: Button = $ItemPanel/ItemButton

# The item in the slot
var item: Dictionary = {}
var selected: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DetailsPanel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_button_pressed() -> void:
	# Can't select the slot if there's nothing
	if item.is_empty():
		button.button_pressed = false
		return
		
	#deselect item if it is already selected
	if selected:
		selected = false
		InventoryManager.selected_item = {}
		button.button_pressed = false
		return
	# another deselection case
	if !InventoryManager.selected_item.is_empty() and InventoryManager.selected_item["name"] == item["name"]:
		selected = false
		button.button_pressed = false
		return
	# if a different item is selected, don't select this one
	# TODO: we will need to add ability for items to combine
	if !InventoryManager.selected_item.is_empty() and InventoryManager.selected_item["name"] != item["name"]:
		selected = false
		button.button_pressed = false
		return
	
	# if all other cases are false, then that means we have a free slot to select this item
	# TODO: defer responsibility to manager
	selected = true
	print("Selected Item: ", item["name"])
	InventoryManager.selected_item = item
	


func _on_item_button_mouse_entered() -> void:
	if !item.is_empty():
		DetailsPanel.visible = true


func _on_item_button_mouse_exited() -> void:
	DetailsPanel.visible = false
	
func set_empty() -> void:
	ItemIcon.texture = null
	item = {}
	ItemName.text = ""
	ItemDescription.text = ""

func set_item(new_item: Dictionary) -> void:
	ItemName.text = new_item["name"]
	ItemIcon.texture = new_item["texture"]
	ItemDescription.text = new_item["description"]
	item = new_item
