extends Node2D

@onready var civilians_left = $CanvasLayer/CiviliansLeft

func _ready():
	Events.dead_ship.connect(_on_dead_civilian)
	_update_text(_count_civilians())

func _on_dead_civilian(dead_ship: Node2D):
	if dead_ship.is_in_group("flock"):
		# The civilian is freed AFTER the signal is sent. So, it won't be counted as dead when we receive the signal.
		var nb_of_civilians_left = _count_civilians() - 1
		_update_text(nb_of_civilians_left)

func _count_civilians():
	return get_tree().get_nodes_in_group("flock").size()

func _update_text(nb_of_civilians_left: int):
	civilians_left.update_text(nb_of_civilians_left)
