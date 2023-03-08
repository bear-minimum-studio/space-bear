extends "res://npc/enemies/ProximityBehavior.gd"

class_name VultureBehavior

func _update_target_position_offset():
	_target_position_offset = distance_to_target * Vector2.DOWN
