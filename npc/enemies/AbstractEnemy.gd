extends "res://npc/AbstractShip.gd"

@export_category("Enemy properties")
@export var kill_bonus = 5

@onready var health_system = $HealthSystem

func _on_behavior_target_position_updated(new_target_position: Vector2):
	set_movement_target(new_target_position)

func _ready():
	super._ready()
	health_system.connect("dead", _earn_reward)

func _earn_reward():
	FlockResources.earn_resources(kill_bonus)
