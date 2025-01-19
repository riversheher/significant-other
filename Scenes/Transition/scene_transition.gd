extends CanvasLayer

@onready var anim_player: AnimationPlayer = $Control/AnimationPlayer

func transition_out(animation: String) -> bool:
	
	anim_player.play(animation)
	
	await anim_player.animation_finished
	return true
	
func transition_in(animation: String) -> bool:
	anim_player.play(animation)
	
	await anim_player.animation_finished
	return true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
