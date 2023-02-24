extends "res://npc/AbstractShip.gd"

@onready var turret = $Turret

func _physics_process(delta):
	super._physics_process(delta)
	var bodies: Array[Node2D] = turret.get_overlapping_bodies()
	var flock_bodies = bodies.filter(func(body): return body.is_in_group("flock"))

	var nearest_body = Helpers.find_nearest_node(self, flock_bodies)
	if nearest_body != null:
		turret.shoot_towards(self, nearest_body)
		self.set_movement_target(self.global_position)
	else:
		var closest_ship = _find_closest_flock_ship()
		if closest_ship != null:
			self.set_movement_target(closest_ship.global_position)

func _find_closest_flock_ship():
	return Helpers.find_nearest_node(self, get_tree().get_nodes_in_group("flock"))
