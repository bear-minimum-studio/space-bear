extends "res://npc/ship-behaviors/TargetShipBehavior.gd"

class_name AutoTargetShipBehavior

func _process(_delta):
	_update_target()
	super._process(_delta)

func _update_target():
	if get_parent() == null:
		printerr("AutoTargetShipBehavior has no get_parent().")
		return
	
	if target == null:
		var potential_targets = get_parent().get_tree().get_nodes_in_group("ally")
		target = Helpers.find_nearest_node(get_parent(), potential_targets)
	_update_target_position_offset()
