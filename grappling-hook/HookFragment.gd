@tool
extends Node2D

@export var neighbour_fragment: NodePath:
	set (new_neighbour_fragment): 
		neighbour_fragment = new_neighbour_fragment
		_set_node_b_value(new_neighbour_fragment)

@onready var pin_joint_2d = $PinJoint2D

func _ready():
	_set_node_b_value(neighbour_fragment)
	
func _set_node_b_value(new_neighbour_fragment):
	if new_neighbour_fragment == null:
		return

	# This suppresses a warning but I don't understand it yet
	if !self.is_inside_tree():
		return

	var node: Node2D = get_node_or_null(new_neighbour_fragment)
	if (node):
		var rigid_body_node_path = node.find_child('RigidBody2D').get_path()
		pin_joint_2d.node_b = rigid_body_node_path 
