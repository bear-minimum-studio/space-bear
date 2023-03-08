extends "res://npc/ship-behaviors/squadron/squadron-behaviors/TargetSquadronBehavior.gd"

class_name AutoTargetSquadronBehavior

func _process(_delta):
	_update_target()
	super._process(_delta)

func _update_target():
	if _parent == null:
		printerr("AutoTargetShipBehavior has no _parent.")
		return
	
	if target == null:
		var potential_targets = _parent.get_tree().get_nodes_in_group("ally")
		target = Helpers.find_nearest_node(_parent, potential_targets)
	_update_target_position_offset()
