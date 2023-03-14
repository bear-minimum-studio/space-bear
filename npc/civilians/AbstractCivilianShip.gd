extends "res://npc/AbstractShip.gd"
class_name AbstractCivilianShip

@export_range(0,10000,1,"or_greater") var number_of_passengers = 0;
@onready var construction_particles = $ConstructionParticles
@export var ship_model = ShipCatalog.ShipModels.CIVILIAN
@export var is_ship_upgradable = true

var contour_material = preload("res://ContourMaterial.tres")
var civilian_malus_scene = preload("res://hud/CivilianMalus.tscn")

var selected = false :
	set(new_value):
		selected = new_value
		if (selected):
			self.material = contour_material
			self.health_bar.force_visibility(true)
		else:
			self.material = null
			self.health_bar.force_visibility(false)

func select():
	selected = true

func unselect():
	selected = false


func set_convoy_path(target_position: Vector2, mothership_position: Vector2):
	# all allies should aim to reach the wormhole while keeping their relative position
	# the allies behind the mothership have a longer way to go
	var mothership_trajectory = target_position - mothership_position
	var direction = mothership_trajectory / mothership_trajectory.length()
	var additional_trajectory = (mothership_position - self.global_position).project(direction)
	var trajectory = mothership_trajectory + additional_trajectory
	behavior.target_position = self.global_position + trajectory

func animate_construction():
	construction_particles.emitting = true

func upgrade(ship_upgrade: ShipCatalogResourceElement):
	var parent = self.get_parent()

	var new_ship = ship_upgrade.scene.instantiate()
	new_ship.global_rotation = self.global_rotation
	new_ship.global_position = self.global_position
	new_ship.velocity = self.velocity
	remove_child(self.behavior)
	new_ship.set_behavior(self.behavior)

	parent.add_child(new_ship)
	
	new_ship.animate_construction()

	self.queue_free()

func _on_dead():
	super._on_dead()
	
	var civilian_malus = civilian_malus_scene.instantiate()
	civilian_malus.init(number_of_passengers)
	civilian_malus.global_position = self.global_position
	WorldReference.current_world.add_child(civilian_malus)
