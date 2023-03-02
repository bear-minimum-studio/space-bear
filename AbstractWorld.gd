extends Node2D

@onready var player = $Player
@onready var flock = $Flock

var explosion_scene = preload("res://explosion/Explosion.tscn")
var player_bullet_scene = preload("res://bullet/PlayerBullet.tscn")
var enemy_bullet_scene = preload("res://bullet/EnemyBullet.tscn")
var grappling_hook_scene = preload("res://grappling-hook/GrapplingHook.tscn")
var current_hook : Node2D

func _ready():
	Events.dead_ship.connect(_on_dead)
	Events.enemy_shoot.connect(_on_enemy_shoot)
	Events.shoot.connect(_on_ally_shoot)
	Events.convoy_reached_wormhole.connect(_on_convoy_reached_wormhole)
	Events.player_reached_wormhole.connect(_on_player_reached_wormhole)


func _on_ally_shoot(global_ally_position, global_ally_rotation, ally_velocity, bullet_speed):
	var ally_direction = Vector2.from_angle(global_ally_rotation);
	var new_bullet = player_bullet_scene.instantiate()
	new_bullet.global_position = global_ally_position
	new_bullet.global_rotation = global_ally_rotation
	new_bullet.set_initial_velocity(ally_velocity, ally_direction, bullet_speed)
	self.add_child(new_bullet)

func _on_enemy_shoot(global_enemy_position, global_enemy_rotation, enemy_velocity, bullet_speed):
	var enemy_direction = Vector2.from_angle(global_enemy_rotation);
	var new_bullet = enemy_bullet_scene.instantiate()
	new_bullet.global_position = global_enemy_position
	new_bullet.global_rotation = global_enemy_rotation
	new_bullet.set_initial_velocity(enemy_velocity, enemy_direction, bullet_speed)
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


func _on_convoy_reached_wormhole():
	print('level ended')

func _on_player_reached_wormhole():
	print('you reached the level end')

func _on_dead(dead_body: Node2D):
	var explosion_scale = 1.0
	if "explosion_scale" in dead_body:
		explosion_scale = dead_body.explosion_scale

	var new_explosion = explosion_scene.instantiate()

	new_explosion.global_position = dead_body.global_position
	# TODO: There should be a method inside explosion instead of a manual scaling
	new_explosion.scale = explosion_scale * Vector2.ONE
	self.add_child(new_explosion)