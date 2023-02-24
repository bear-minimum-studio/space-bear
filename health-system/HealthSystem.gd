@icon("res://health-system/health_icon.svg")
class_name HealthSystem
extends Node2D

@export_range(1, 200) var max_health = 1

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
