extends Node2D

class_name AbstractSquadronBehavior

@onready var target_position : Vector2 = get_parent().global_position:
	set(new_target_position):
		if new_target_position == null:
			return
		target_position = new_target_position
		get_parent().movement_target = target_position
