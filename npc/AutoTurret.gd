@tool
extends "res://npc/BulletTurret.gd"

@export_range(0.0, 500.0, 10.0, "or_greater") var turret_range: float = 250.0 :
	set(new_turret_range):
		turret_range = new_turret_range
		_update_range()

@onready var collision_shape_2d = $CollisionShape2D

func _compute_shooting_corretion(shoot_target: PhysicsBody2D) -> Vector2:
	var shooter_velocity = Helpers.get_velocity(shooter)
	var target_velocity = Helpers.get_velocity(shoot_target)
	return (target_velocity - shooter_velocity) / bullet_speed

func _ready():
	_update_range()

func _update_range():
	if collision_shape_2d == null:
		return

	collision_shape_2d.shape.radius = turret_range
