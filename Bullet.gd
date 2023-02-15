extends Sprite2D

const SPEED = 500

func _process(delta):
	# TODO: we should probably use physics nodes?
	translate(Vector2(delta * SPEED * cos(self.rotation), delta * SPEED * sin(self.rotation)))
