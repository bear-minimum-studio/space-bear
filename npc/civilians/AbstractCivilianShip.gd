extends "res://npc/AbstractShip.gd"
class_name AbstractCivilianShip

@export_range(0,10000,1,"or_greater") var number_of_passengers = 0;
@onready var construction_particles = $ConstructionParticles

var civilian_malus_scene = preload("res://hud/CivilianMalus.tscn")

func set_convoy_path(target_position: Vector2, mothership_position: Vector2):
	# all allies should aim to reach the wormhole while keeping their relative position
	# the allies behind the mothership have a longer way to go
	var mothership_trajectory = target_position - mothership_position
	var direction = mothership_trajectory / mothership_trajectory.length()
	var additional_trajectory = (mothership_position - self.global_position).project(direction)
	var trajectory = mothership_trajectory + additional_trajectory
	movement_target = self.global_position + trajectory

func animate_construction():
	construction_particles.emitting = true

func upgrade():
	var parent = self.get_parent()

	var new_ship_scene = ShipCatalog.catalog.get_current_ship_scene()
	var new_ship = new_ship_scene.instantiate()
	new_ship.global_rotation = self.global_rotation
	new_ship.global_position = self.global_position
	new_ship.velocity = self.velocity

	parent.add_child(new_ship)
	new_ship.animate_construction()

	new_ship.movement_target = self.movement_target

	self.queue_free()

func _on_dead():
	super._on_dead()
	
	var civilian_malus = civilian_malus_scene.instantiate()
	civilian_malus.init(number_of_passengers)
	civilian_malus.global_position = self.global_position
	WorldReference.current_world.add_child(civilian_malus)
