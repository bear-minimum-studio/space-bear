extends Node2D

@onready var flock = $Flock
@onready var mother_ship = $Flock/MotherShip
@onready var wormhole = $Wormhole

func _ready():
	WorldReference.current_world = self
	get_tree().call_group("flock", "set_convoy_path", wormhole.global_position, mother_ship.global_position)
