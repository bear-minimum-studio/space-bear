extends "res://npc/civilians/AbstractCivilianShip.gd"

class_name MotherShip

func _on_health_system_hp_changed(health, max_health, difference):
	super(health, max_health, difference)
	Events.mothership_hp_changed.emit(health, max_health)
