extends "res://npc/AbstractShip.gd"

var health = 10

func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()

func _on_hit_box_body_entered(body):
	if body.has_method("on_hit"):
		body.on_hit()
