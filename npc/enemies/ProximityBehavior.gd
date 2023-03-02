extends "res://npc/enemies/AbstractBehavior.gd"

var distance_to_target : float = 0.0

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
	var vect_to_target = _target.global_position - _parent.global_position
	if vect_to_target != Vector2.ZERO:
		_target_position_offset = - distance_to_target * vect_to_target.normalized()
	else:
		_target_position_offset = Vector2.ZERO

func _update_target_position():
	if _target == null:
		_target_position = _parent.global_position
		return
	
	_target_position = _target.global_position + _target_position_offset
