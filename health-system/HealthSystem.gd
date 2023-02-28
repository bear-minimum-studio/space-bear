@icon("res://health-system/health_icon.svg")
class_name HealthSystem
extends Node2D

@export_range(1, 200, 1, "or_greater") var max_health = 1:
	set(new_max_health):
		# If max_health initialization is done after ready,
		# we need to synchronize health and max health
		if health == max_health:
			health = new_max_health

		max_health = new_max_health

@onready var health = max_health

signal hp_changed
signal dead

func on_hit():
	if health > 0:
		health -= 1
	hp_changed.emit(health, max_health)
	if health <= 0:
		dead.emit()
		get_parent().queue_free()
