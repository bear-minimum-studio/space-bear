extends "res://npc/ship-behaviors/AutoTargetShipBehavior.gd"

class_name VultureShipBehavior

func _update_target_position_offset():
	_target_position_offset = distance_to_target * Vector2.DOWN
