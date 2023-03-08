extends Node

@onready var _parent: AbstractShip = get_parent()
@onready var _target: Node2D = null:
	set(new_target):
		if new_target == null || _target == new_target:
			return
		_target = new_target
		_update_target_position()
@onready var _target_position : Vector2 = _parent.global_position:
	set(new_target_position):
		if new_target_position == null:
			return
		_target_position = new_target_position
		_parent.movement_target = _target_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_update_target()
	_update_target_position()

func _update_target():
	if _target == null:
		_target = Helpers.find_nearest_node(_parent, _parent.get_tree().get_nodes_in_group("ally"))

func _update_target_position():
	if _target == null and _parent == null:
		return
	
	if _target == null:
		_target_position = _parent.global_position
	
	_target_position = _target.global_position
