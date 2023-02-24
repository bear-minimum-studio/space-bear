extends "res://npc/AbstractShip.gd"

@onready var turret = $Turret

func _physics_process(delta):
	super._physics_process(delta)
	var bodies: Array[Node2D] = turret.get_overlapping_bodies()
	var flock_bodies = bodies.filter(func(body): return body.is_in_group("enemy"))

	var nearest_body = Helpers.find_nearest_node(self, flock_bodies)
	if nearest_body != null:
		turret.shoot_towards(self, nearest_body)
	else:
		turret.global_rotation = self.global_rotation
