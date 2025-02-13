extends Node2D

@export var anim_player: AnimationPlayer
@export var autoplay: bool = false

func _ready() -> void:
	PlayerManager.player.queue_free()
	AudioPlayer.play()

func _input(event):
	if event.is_action_pressed("next") and not anim_player.is_playing():
		anim_player.play()

func pause():
	if autoplay == false:
		anim_player.pause()
		

func change_scene():
	PlayerManager.add_player_instance()
	LevelManager.to_retry()
