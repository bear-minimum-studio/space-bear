extends Node2D

@onready var civilians_left = $CanvasLayer/CiviliansLeft

var nb_of_civilians

func _ready():
	Events.dead_ship.connect(_on_dead_civilian)
	nb_of_civilians = _count_civilians()
	_update_text(nb_of_civilians)

func _on_dead_civilian(dead_ship: Node2D):
	if dead_ship.is_in_group("flock"):
		nb_of_civilians = _count_civilians() - 1
		_update_text(nb_of_civilians)

func _count_civilians():
	return get_tree().get_nodes_in_group("flock").size()

func _update_text(nb_of_civilians: int):
	civilians_left.update_text(nb_of_civilians)
