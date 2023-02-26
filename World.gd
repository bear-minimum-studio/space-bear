extends Node2D

@onready var player = $Player
@onready var mother_ship = $MotherShip
@onready var flock = $Flock
@onready var target = $Target

const BULLET_SPEED = Bullet.BULLET_SPEED
const MINIMAL_BULLET_SPEED = BULLET_SPEED

var player_bullet_scene = preload("res://bullet/PlayerBullet.tscn")
var enemy_bullet_scene = preload("res://bullet/EnemyBullet.tscn")
var grappling_hook_scene = preload("res://grappling-hook/GrapplingHook.tscn")
var current_hook : Node2D



func _ready():
	get_tree().call_group("flock", "set_movement_target", target.global_transform.origin)
	mother_ship.set_movement_target(target.global_transform.origin)
	Events.enemy_shoot.connect(_on_enemy_shoot)
	Events.shoot.connect(_on_player_shoot)


func _on_player_shoot(global_player_position, global_player_rotation, player_velocity):
	var player_direction = Vector2.from_angle(global_player_rotation);
	var new_bullet = player_bullet_scene.instantiate()
	new_bullet.global_position = global_player_position
	new_bullet.global_rotation = global_player_rotation
	new_bullet.set_initial_velocity(player_velocity, player_direction)
	self.add_child(new_bullet)

func _on_enemy_shoot(global_enemy_position, global_enemy_rotation, enemy_velocity):
	var enemy_direction = Vector2.from_angle(global_enemy_rotation);
	var new_bullet = enemy_bullet_scene.instantiate()
	new_bullet.global_position = global_enemy_position
	new_bullet.global_rotation = global_enemy_rotation
	new_bullet.set_initial_velocity(enemy_velocity, enemy_direction)
	self.add_child(new_bullet)

func _on_player_shoot_grappling_hook(global_player_position, global_player_rotation):
	# If shooting again while a grappling hook exists, delete the current one
	if current_hook != null:
		current_hook.queue_free()
		current_hook = null
		return

	var new_hook = grappling_hook_scene.instantiate()
	
	new_hook.global_position = global_player_position
	new_hook.global_rotation = global_player_rotation

	self.add_child(new_hook)

	current_hook = new_hook
	new_hook.launch(player, global_player_rotation)
