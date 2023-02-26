extends Area2D
class_name Bullet

@export var bullet_range = 10000

# Exported value, do not rename
# TODO: make this internal
const BULLET_SPEED = 500

var velocity = Vector2.ZERO;
var initial_position = null

func _ready():
	$SFX.play()
	initial_position = self.global_position

func _process(delta):
	translate(delta * velocity)
	if (self.global_position - initial_position).length() > bullet_range:
		self.queue_free()


func _on_body_entered(body: Node2D):
	var health_system = body.find_child("HealthSystem")
	if health_system != null:
		health_system.on_hit()
	self.queue_free()
