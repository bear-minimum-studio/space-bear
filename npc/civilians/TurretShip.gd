extends "res://npc/AbstractShip.gd"

@export_range(0.5,50.0) var bullets_per_second = 5.0
@export_range(1, 50) var health = 5

@onready var shooting_speed = 1.0 / bullets_per_second
@onready var fire_range = $FireRange
var _reloading = false

# TODO this is a lot of copy/paste from Enemy
func _physics_process(delta):
	super._physics_process(delta)
	var bodies: Array[Node2D] = fire_range.get_overlapping_bodies()
	var flock_bodies = bodies.filter(func(body): return body.is_in_group("enemy"))

	var nearest_body = Helpers.find_nearest_node(self, flock_bodies)
	if nearest_body != null:
		_shoot_towards(nearest_body)

func _find_closest_enemy_ship():
	return Helpers.find_nearest_node(self, get_tree().get_nodes_in_group("enemy"))

# TODO this is a lot of copy/paste from Enemy and Player
func _shoot_towards(body: Node2D):
	self.look_at(body.global_position)

	if _reloading:
		return

	Events.emit_signal("shoot", global_position, global_rotation, velocity)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false

# TODO refactor this into a separate node, this is copy pasted from all NPCs
func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()
