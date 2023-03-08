extends Node

@onready var _parent: AbstractShip = get_parent()
@onready var _target_position : Vector2 = _parent.global_position:
	set(new_target_position):
		if new_target_position == null:
			return
		_target_position = new_target_position
		_parent.movement_target = _target_position
