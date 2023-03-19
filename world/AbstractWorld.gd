extends Node2D

class_name AbstractWorld

# Do not rename, used publicly
@onready var player = $Player
# Do not rename, used publicly
@onready var camera = $Player/Camera2D
# Do not rename, used publicly
@onready var mother_ship = $Flock/MotherShip

@onready var flock = $Flock
@onready var wormhole = $Wormhole
@onready var squadrons_handler = $SquadronsHandler
@onready var initial_distance_to_wormhole = (wormhole.global_position - mother_ship.global_position).length()

@export_multiline var mission = ""

func _ready():
	WorldReference.current_world = self
	var initial_flock = get_node_or_null("Flock/InitialFlock")
	if initial_flock != null:
		initial_flock.initialize()
	get_tree().call_group("flock", "set_convoy_path", wormhole.global_position, mother_ship.global_position)

func _get_wormhole_percentage():
	if mother_ship == null:
		# Happens if the mothership dies
		# The game should restart immediately, we show a 0 progress for only one frame
		return 0

	var distance_to_wormhole_center = (wormhole.global_position - mother_ship.global_position).length()
	var distance_to_wormhole_exterior = distance_to_wormhole_center - wormhole.get_collision_size()
	var initial_distance_to_wormhole_exterior = initial_distance_to_wormhole - wormhole.get_collision_size()
	return  1 - (distance_to_wormhole_exterior / initial_distance_to_wormhole_exterior)

func _physics_process(_delta):
	Events.mothership_advance.emit(_get_wormhole_percentage())

func get_global_position_to_fleet_proportion(node: Node2D) -> float:
	return mother_ship.get_global_position_to_fleet_proportion(node)

