@tool
extends "res://weapons/turrets/healing-turrets/HealingTurret.gd"

@export_range(0.0, 500.0, 10.0, "or_greater") var turret_range: float = 250.0 :
	set(new_turret_range):
		turret_range = new_turret_range
		_update_range()

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	_update_range()

func _update_range():
	if collision_shape_2d == null:
		return

	collision_shape_2d.shape.radius = turret_range
