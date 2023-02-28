extends "res://npc/AbstractShip.gd"

@export_range(0.0,1.0) var proximity_ratio = 0.8

@onready var turret = $Turret
@onready var turret_range = turret.turret_range

var targetted_ship: Node2D
var _target_position_offset: Vector2

func _ready():
	pass

func _physics_process(delta):
	super._physics_process(delta)
	_set_targetted_positon()

func _find_closest_flock_ship():
	return Helpers.find_nearest_node(self, get_tree().get_nodes_in_group("flock"))

func _set_targetted_positon():
	if targetted_ship == null:
		targetted_ship = _find_closest_flock_ship()
		
		if targetted_ship == null:
			set_movement_target(global_position)
			return
		
		var vect_to_target = targetted_ship.global_position - global_position
		_target_position_offset = - proximity_ratio * turret_range * vect_to_target.normalized()
	
	var target_position = targetted_ship.global_position + _target_position_offset
	set_movement_target(target_position)
