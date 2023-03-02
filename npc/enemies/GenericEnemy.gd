extends "res://npc/AbstractShip.gd"

func _on_behavior_target_position_updated(new_target_position: Vector2):
	set_movement_target(new_target_position)
