extends CharacterBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("idle")
