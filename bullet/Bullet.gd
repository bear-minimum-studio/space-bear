extends Area2D

var velocity = Vector2.ZERO;

func _ready():
	$SFX.play()

func _process(delta):
	translate(delta * velocity)


func _on_body_entered(body):
	if (body.has_method("on_hit")):
		body.on_hit()

	self.queue_free()
