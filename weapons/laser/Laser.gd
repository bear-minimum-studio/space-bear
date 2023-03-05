@tool
extends Node2D

@onready var line_2d = $Line2D
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer

@export var laser_range = 500.0:
	set(new_range):
		laser_range = new_range
		_update_sprite_length(laser_range)
		_update_raycast_range(laser_range)

func _ready():
	_update_raycast_range(laser_range)
	
	ray_cast_2d.force_raycast_update()
	var coll = ray_cast_2d.get_collision_point()
	var distance
	if coll == Vector2.ZERO:
		distance = laser_range
	else:
		var body_or_area = ray_cast_2d.get_collider()
		_hit(body_or_area)
		distance = (coll - global_position).length()
	
	_update_sprite_length(distance)
	
	await animation_player.animation_finished
	self.queue_free()

func _update_raycast_range(length: float):
	if ray_cast_2d == null:
		return

	ray_cast_2d.target_position = length * Vector2.RIGHT

func _update_sprite_length(length: float):
	if line_2d == null:
		return

	var last_point_index = line_2d.get_point_count() - 1
	line_2d.set_point_position(last_point_index, length * Vector2.RIGHT)

func _hit(area_or_body):
	var health_system = area_or_body.find_child("HealthSystem")
	if health_system != null:
		health_system.on_hit()