extends Area2D

@export var bullet_range = 10000
@export var bullet_speed = 500

var minimal_bullet_speed:
	get: return bullet_speed

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
	_hit(body)

func _on_area_entered(area):
	_hit(area)

func _hit(area_or_body):
	var health_system = area_or_body.find_child("HealthSystem")
	if health_system != null:
		health_system.on_hit()
	self.queue_free()

# Computes new bullet speed using player orientation and velocity
# Ensures that no bullet is slower than the minimal bullet speed
func set_initial_velocity(shooter_velocity : Vector2, shooter_direction : Vector2) -> void:
	var new_bullet_velocity = shooter_velocity + bullet_speed * shooter_direction
	# If we cant get a direction from the bullet velocity we use
	# the player_direction as the bullet direction.
	if new_bullet_velocity == Vector2.ZERO:
		new_bullet_velocity = minimal_bullet_speed * shooter_direction
	# Making sure no bullet goes slower than the minimal bullet speed
	if new_bullet_velocity.length() < minimal_bullet_speed:
		new_bullet_velocity = minimal_bullet_speed * new_bullet_velocity.normalized()
	
	velocity = new_bullet_velocity
