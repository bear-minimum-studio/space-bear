extends "res://npc/AbstractShip.gd"

@export_range(0.5,50.0) var bullets_per_second = 5.0
@export_range(1, 50) var health = 5

@onready var shooting_speed = 1.0 / bullets_per_second
@onready var fire_range = $FireRange
var _reloading = false


func _physics_process(delta):
	var bodies: Array[Node2D] = fire_range.get_overlapping_bodies()
	
	var nearest_body = null
	var distance = null
	for body in bodies:
		if body.is_in_group("flock"):
			var current_distance = self.transform.origin.distance_to(body.transform.origin)
			if distance == null:
				nearest_body = body
				distance = current_distance
			elif current_distance < distance:
				nearest_body = body
				distance = current_distance
	
	if nearest_body != null:
		_shoot_towards(nearest_body)


func _shoot_towards(body: Node2D):
	self.look_at(body.global_transform.origin)

	if _reloading:
		return

	Events.emit_signal("enemy_shoot", global_position, global_rotation, velocity)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false

func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()
