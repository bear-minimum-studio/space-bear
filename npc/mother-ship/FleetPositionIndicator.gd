extends Node2D

@onready var fleet_end = $FleetEnd
var furthest_relative_position: Vector2

func _ready():
	var furthest = Helpers.find_furthest_node(self, get_tree().get_nodes_in_group("flock"))
	fleet_end.global_position = furthest.global_position
	furthest_relative_position = fleet_end.position

func get_fleet_proportion_position(proportion: float) -> Vector2:
	return to_global(furthest_relative_position * proportion)

func get_global_position_to_fleet_proportion(node: Node2D) -> float:
	var reference = node.global_position

	var local_coordinates_of_reference = to_local(reference)
	var local_position_projected_on_fleet = local_coordinates_of_reference.project(fleet_end.position)

	return (local_position_projected_on_fleet.length() / furthest_relative_position.length())
