extends Area2D
class_name Bullet

@export var bullet_range = 10000

# Exported value, do not rename
# TODO: make this internal
const BULLET_SPEED = 500
const MINIMAL_BULLET_SPEED = BULLET_SPEED

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

# Computes new bullet speed using player orientation and velocity
# Ensures that no bullet is slower than the minimal bullet speed
func set_initial_velocity(shooter_velocity : Vector2, shooter_direction : Vector2) -> void:
	var new_bullet_velocity = shooter_velocity + BULLET_SPEED * shooter_direction
	# If we cant get a direction from the bullet velocity we use
	# the player_direction as the bullet direction.
	if new_bullet_velocity == Vector2.ZERO:
		new_bullet_velocity = MINIMAL_BULLET_SPEED * shooter_direction
	# Making sure no bullet goes slower than the minimal bullet speed
	if new_bullet_velocity.length() < MINIMAL_BULLET_SPEED:
		new_bullet_velocity = MINIMAL_BULLET_SPEED * new_bullet_velocity.normalized()
	
	velocity = new_bullet_velocity
