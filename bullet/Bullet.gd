extends Area2D

class_name Bullet

const BULLET_SPEED = 500

var velocity = Vector2.ZERO;

func _ready():
	$SFX.play()

func _process(delta):
	translate(delta * velocity)


func _on_body_entered(body: Node2D):
	var health_system = body.find_child("HealthSystem")
	if health_system != null:
		health_system.on_hit()
	self.queue_free()
