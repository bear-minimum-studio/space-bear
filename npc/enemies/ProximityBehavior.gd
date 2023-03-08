extends "res://npc/AbstractShipBehavior.gd"

class_name ProximityBehavior

@export_range(0.0, 500.0, 25.0, "or_greater") var distance_to_target : float = 0.0:
	set(new_distance_to_target):
		if new_distance_to_target == null:
			return
		distance_to_target = new_distance_to_target
		_update_target_position_offset()

var _target_position_offset: Vector2 = Vector2.ZERO:
	set(new_target_position_offset):
		if new_target_position_offset == null:
			return
		_target_position_offset = new_target_position_offset
		_update_target_position()

func _update_target():
	super._update_target()
	_update_target_position_offset()

func _update_target_position_offset():
	if _target == null:
		return
	var vect_to_target = _target.global_position - _parent.global_position
	if vect_to_target != Vector2.ZERO:
		_target_position_offset = - distance_to_target * vect_to_target.normalized()
	else:
		_target_position_offset = Vector2.ZERO

func _update_target_position():
	if _target == null and _parent == null:
		return
	
	if _target == null:
		_target_position = _parent.global_position
		return
	
	_target_position = _target.global_position + _target_position_offset
