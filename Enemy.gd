extends CharacterBody2D

var health = 10

func on_hit():
	health -= 1

	if (health <= 0):
		self.queue_free()
