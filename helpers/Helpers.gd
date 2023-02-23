class_name Utils

extends Node2D

# Second argument is array of nodes. Can't type it properly though,
# because sometimes it is Node2D and sometimes Node
func find_nearest_node(reference: Node2D, other_nodes: Array):
	var nearest = null
	var distance = null
	for current_node in other_nodes:
		var current_distance = reference.global_position.distance_to(current_node.global_position)
		if distance == null:
			nearest = current_node
			distance = current_distance
		elif current_distance < distance:
			nearest = current_node
			distance = current_distance

	return nearest
