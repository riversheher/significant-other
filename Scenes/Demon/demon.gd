class_name Demon extends CharacterBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("idle")
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func move_towards(pos: Vector2) -> void:
	var current_position: Vector2 = self.global_position
	velocity = pos - current_position
	velocity.normalized()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		velocity = Vector2.ZERO
		LevelManager.demon_collision.emit()
