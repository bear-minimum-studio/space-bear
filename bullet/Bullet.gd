extends Area2D

var velocity = Vector2.ZERO;

func _ready():
	$SFX.set_pitch_scale(randf_range(0.95,1.1))
	$SFX.play(0)

func _process(delta):
	translate(delta * velocity)

func _on_area_2d_body_entered(body):
	if (body.has_method("on_hit")):
		body.on_hit()

	self.queue_free()
