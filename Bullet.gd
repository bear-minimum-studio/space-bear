extends Node2D

const SPEED = 500

func _process(delta):
	# TODO: we should probably use physics nodes?
	translate(Vector2(delta * SPEED * cos(self.rotation), delta * SPEED * sin(self.rotation)))


func _on_area_2d_body_entered(body):
	if (body.has_method("on_hit")):
		body.on_hit()

	self.queue_free()
