extends Label

var nb_of_civilians
func _ready():
	Events.dead_ship.connect(_on_dead_civilian)
	nb_of_civilians = get_tree().get_nodes_in_group("flock").size()
	_update_text()

func _on_dead_civilian(dead_ship: Node2D):
	if dead_ship.is_in_group("flock"):
		nb_of_civilians = get_tree().get_nodes_in_group("flock").size() - 1
		_update_text()

func _update_text():
	self.text = "%s civilian ships left" % nb_of_civilians
