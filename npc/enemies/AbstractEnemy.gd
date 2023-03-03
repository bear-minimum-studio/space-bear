extends "res://npc/AbstractShip.gd"

@export_category("Enemy properties")
@export var kill_bonus = 5

@onready var health_system = $HealthSystem

var bonus_resources_scene = preload("res://hud/BonusResources.tscn")

func _on_behavior_target_position_updated(new_target_position: Vector2):
	set_movement_target(new_target_position)

func _on_dead():
	super._on_dead()
	FlockResources.earn_resources(kill_bonus)

	var bonus_resources = bonus_resources_scene.instantiate()
	bonus_resources.init(kill_bonus)
	bonus_resources.global_position = self.global_position
	WorldReference.current_world.add_child(bonus_resources)
