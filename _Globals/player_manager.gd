extends Node

var PLAYER = preload("res://Scenes/Player/player.tscn")
var DEMON = preload("res://Scenes/Demon/demon.tscn")
var player : Player
var demon : Demon
var player_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.1).timeout
	player_spawned = true

# add_player_instance adds the global player object to a scene
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	
func add_demon_instance() -> void:
	demon = DEMON.instantiate()
	add_child(demon)

func set_player_position(pos: Vector2) -> void:
	player.global_position = pos
	
func set_demon_position(pos: Vector2) -> void:
	demon.global_position = pos

func set_as_parent(par : Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	par.add_child(player)
	
func set_demon_parent(par: Node2D) -> void:
	if demon.get_parent():
		demon.get_parent().remove_child(demon)
	par.add_child(demon)

func unparent_player(par: Node2D) -> void:
	par.remove_child(player)
	
func unparent_demon(par: Node2D) -> void:
	par.remove_child(demon)

func reset_player_state() -> void:
	player.reset_state()
	
func lock_player_movement() -> void:
	player.can_move = false
	
func allow_player_movement() -> void:
	player.can_move = true
