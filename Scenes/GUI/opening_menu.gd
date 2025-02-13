extends CanvasLayer


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@export var opening_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.stop()
	audio_player.play()
	


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(opening_scene)
