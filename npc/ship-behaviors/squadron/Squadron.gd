extends Node2D

class_name Squadron

var id: String = ""
var ships: Array[AbstractShip] = []
var nb_ships: int

var avoidance_factor: float = 2.0
var alignment_factor: float = 2.0
var cohesion_factor: float = 1.0
var squadron_target_factor: float = 5.0
var velocity_factor: float = 1.0
var avoidance_range: float = 100.0

@export var default_behavior_scene: PackedScene
@export var debug_enabled : bool = false

var behavior : AbstractSquadronBehavior
var movement_target = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	if default_behavior_scene != null and behavior == null:
		set_behavior(default_behavior_scene)

func _process(_delta):
	_update_ships()
	_update_position()
	_update_velocity()
	queue_redraw()

func remove_behavior():
	if behavior != null:
		behavior.free()

func set_behavior(behavior_scene: PackedScene):
	remove_behavior()
	var new_behavior = behavior_scene.instantiate()
	add_child(new_behavior)
	behavior = new_behavior

func _update_ships():
	ships = ships.filter(func(ship): return ship != null)
	nb_ships = ships.size()
	if nb_ships < 1:
		queue_free()

func _update_position():
	var accumulator = Vector2.ZERO
	for ship in ships:
		if ship == null:
			continue
		accumulator += ship.global_position
	if nb_ships == 0:
		global_position = Vector2.ZERO
	else:
		global_position = accumulator / nb_ships

func _update_velocity():
	var accumulator = Vector2.ZERO
	for ship in ships:
		if ship == null:
			continue
		accumulator += Helpers.get_velocity(ship)
	if nb_ships == 0:
		velocity = Vector2.ZERO
	else:
		velocity = accumulator / nb_ships

func add_ship(new_ship: AbstractShip):
	ships.push_back(new_ship)
	nb_ships += 1

func remove_ship(ship_to_remove: AbstractShip):
	ships.erase(ship_to_remove)
	nb_ships -= 1

func _draw():
	if debug_enabled:
		# Target
		draw_line(Vector2.ZERO, movement_target - global_position, Color.MAGENTA, 2.0)

func _exit_tree():
	WorldReference.current_world.squadrons_handler.remove_squadron(id)
