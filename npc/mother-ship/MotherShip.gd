extends "res://npc/civilians/AbstractCivilianShip.gd"

func _on_health_system_hp_changed(health, max_health, _difference):
	Events.mothership_hp_changed.emit(health, max_health)
