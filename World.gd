extends "res://AbstractWorld.gd"

@onready var mother_ship = $MotherShip
@onready var wormhole = $Wormhole

func _ready():
	super._ready()
	get_tree().call_group("flock", "set_convoy_path", wormhole.global_position, mother_ship.global_position)
