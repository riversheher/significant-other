class_name ThoughtUI extends Control


var current_thought: String = ""
@onready var thought_box: Label = $ThoughtPanel/ThoughtText

func _ready() -> void:
	InventoryManager.thought_changed.connect(change_thought)

func change_thought() -> void:
	current_thought = InventoryManager.current_thought
	thought_box.text = current_thought
	
