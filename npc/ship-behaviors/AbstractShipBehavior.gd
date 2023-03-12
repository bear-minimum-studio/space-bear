extends Node2D

class_name AbstractShipBehavior

var previous_target_position = null

@onready var target_position : Vector2:
	set(new_target_position):
		if new_target_position == null:
			return
		target_position = new_target_position
		get_parent().movement_target = target_position

func _enter_tree():
	if previous_target_position != null:
		target_position = previous_target_position

func _exit_tree():
	previous_target_position = target_position
