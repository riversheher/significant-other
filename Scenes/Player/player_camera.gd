extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_limits(top_left: Vector2, bottom_right: Vector2) -> void:
	self.limit_left = top_left.x
	self.limit_top = top_left.y
	self.limit_bottom = bottom_right.y
	self.limit_right = bottom_right.x
