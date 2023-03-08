extends Node2D

class_name AbstractSquadronBehavior

@onready var _parent: Squadron = get_parent()
@onready var _target_position : Vector2 = _parent.global_position:
	set(new_target_position):
		if _parent == null:
			printerr("AbstractShipBehavior has no _parent.")
			return
		if new_target_position == null:
			return
		_target_position = new_target_position
		_parent.movement_target = _target_position
