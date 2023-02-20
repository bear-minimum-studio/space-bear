@tool
extends RigidBody2D

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
		
	if new_neighbour_fragment:
		pin_joint_2d.node_b = new_neighbour_fragment

