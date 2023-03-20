extends "res://npc/civilians/AbstractCivilianShip.gd"

class_name MotherShip

@onready var fleet_position_indicator = $FleetPositionIndicator

func _on_health_system_hp_changed(health, max_health, difference):
	super(health, max_health, difference)
	Events.mothership_hp_changed.emit(health, max_health, difference)

func _on_dead():
	super._on_dead()
	ship.visible = false
	flammes.visible = false

func get_global_position_to_fleet_proportion(node: Node2D) -> float:
	return fleet_position_indicator.get_global_position_to_fleet_proportion(node)
