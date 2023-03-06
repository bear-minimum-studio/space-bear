@icon("res://health-system/health_icon.svg")
class_name HealthSystem
extends Node2D

@export var hurtable_body: CollisionObject2D
@export var healable = false

@export_range(1, 200, 1, "or_greater") var max_health = 1:
	set(new_max_health):
		# If max_health initialization is done after ready,
		# we need to synchronize health and max health
		if health == max_health:
			health = new_max_health

		max_health = new_max_health

@onready var health = max_health

@export var should_free_on_death = true

const COLLISION_LAYER = 8

signal hp_changed
signal dead

func on_hit():
	var previous_health = health

	if health <= 0:
		# already dead
		return
	
	if health > 0:
		health -= 1
	_on_health_change(previous_health)

	if health <= 0:
		dead.emit()
		if should_free_on_death:
			get_parent().queue_free()

func heal_to_max():
	var previous_health = health
	health = max_health
	_on_health_change(previous_health)

static func hit_health_system(node: Node2D):
	var health_system = node.find_child('HealthSystem')
	if health_system != null:
		health_system.on_hit()

func heal():
	var previous_health = health
	health += 10
	if health > max_health:
		health = max_health
	_on_health_change(previous_health)

func _on_health_change(previous_health: int):
	var difference = health - previous_health
	hp_changed.emit(health, max_health, difference)
	
	if hurtable_body != null and healable:
		if health != max_health:
			hurtable_body.set_collision_layer_value(COLLISION_LAYER, true)
		else:
			hurtable_body.set_collision_layer_value(COLLISION_LAYER, false)
