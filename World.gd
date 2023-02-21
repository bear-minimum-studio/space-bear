extends Node2D

@onready var player = $Player
@onready var mother_ship = $MotherShip
@onready var flock = $Flock
@onready var target = $Target

# TODO : Move it elsewhere
const BULLET_SPEED = 500
const MINIMAL_BULLET_SPEED = BULLET_SPEED

var bullet_scene = preload("res://bullet/Bullet.tscn")
var grappling_hook_scene = preload("res://grappling-hook/GrapplingHook.tscn")

var current_hook : Node2D



func _ready():
	get_tree().call_group("flock", "set_target_offset", mother_ship.global_transform.origin)
	mother_ship.set_movement_target(target.global_transform.origin)


func _on_player_shoot(global_player_position, global_player_rotation, player_velocity):
	var player_direction = Vector2.from_angle(global_player_rotation);
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = global_player_position
	new_bullet.global_rotation = global_player_rotation
	new_bullet.velocity = _compute_bullet_velocity(player_velocity, player_direction)
	self.add_child(new_bullet)

# Computes new bullet speed using player orientation and velocity
# Ensures that no bullet is slower than the minimal bullet speed
func _compute_bullet_velocity(player_velocity : Vector2, player_direction : Vector2) -> Vector2:
	var new_bullet_velocity = player_velocity + BULLET_SPEED * player_direction
	# If we cant get a direction from the bullet velocity we use
	# the player_direction as the bullet direction.
	if new_bullet_velocity == Vector2.ZERO:
		new_bullet_velocity = MINIMAL_BULLET_SPEED * player_direction
	# Making sure no bullet goes slower than the minimal bullet speed
	if new_bullet_velocity.length() < MINIMAL_BULLET_SPEED:
		new_bullet_velocity = MINIMAL_BULLET_SPEED * new_bullet_velocity.normalized()
	return new_bullet_velocity

func _on_player_shoot_grappling_hook(global_player_position, global_player_rotation):
	var new_hook = grappling_hook_scene.instantiate()
	
	new_hook.global_position = global_player_position
	new_hook.global_rotation = global_player_rotation

	self.add_child(new_hook)
	
	if current_hook:
		current_hook.queue_free()
		
	current_hook = new_hook
	new_hook.launch(player, global_player_rotation)

func _physics_process(_delta):
	get_tree().call_group("flock", "set_movement_target", mother_ship.global_transform.origin)
