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

@export var should_free_on_death = true

signal hp_changed
signal dead

func on_hit():
	if health <= 0:
		# already dead
		return
	
	if health > 0:
		health -= 1
	hp_changed.emit(health, max_health)

	if health <= 0:
		dead.emit()
		if should_free_on_death:
			get_parent().queue_free()

func heal_to_max():
	health = max_health
	hp_changed.emit(health, max_health)

static func hit_health_system(node: Node2D):
	var health_system = node.find_child('HealthSystem')
	if health_system != null:
		health_system.on_hit()
