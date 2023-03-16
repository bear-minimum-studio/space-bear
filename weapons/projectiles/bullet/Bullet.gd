extends Area2D

@export var bullet_range = 1000
@export var damage = 1

@onready var bullet_impact = $BulletImpact

var velocity = Vector2.ZERO;
var initial_position = null

func init(global_shooter_position, global_shooter_rotation, shooter_velocity, bullet_speed, bullet_damage, bullet_size_scale = 1):
	damage = bullet_damage
	var shooter_direction = Vector2.from_angle(global_shooter_rotation);
	global_position = global_shooter_position
	global_rotation = global_shooter_rotation
	scale = self.scale * bullet_size_scale
	set_initial_velocity(shooter_velocity, shooter_direction, bullet_speed)
	WorldReference.current_world.add_child(self)

func _ready():
	$SFX.play()
	initial_position = self.global_position

func _process(delta):
	translate(delta * velocity)
	if (self.global_position - initial_position).length() > bullet_range:
		self.queue_free()

# Upon collision, we won't call hit immediately
# because we could have both an area and a body colliding
# We defer the call and so that we'll be able to check
# if there's both a body and an area
var _colliding_objects = []
func _on_body_entered(body: Node2D):
	_colliding_objects.append(body)
	call_deferred("_hit")

func _on_area_entered(area):
	_colliding_objects.append(area)
	call_deferred("_hit")

func _hit():
	# If we've been called multiple times, we won't call hit again
	if _colliding_objects.size() == 0:
		return

	# We want to prioritize a shield hit over anything else that's being hit by the bullet
	var shield_victim = Helpers.find_in_array(_colliding_objects, func(elem): return elem is Shield)
	# If no shield has been hit, just take the first victim of the array
	var victim = shield_victim if shield_victim != null else _colliding_objects[0]
	
	HealthSystem.hit_health_system(victim, damage)
	
	_colliding_objects = []
	_disable_bullet()
	bullet_impact.adapt_style_then_play(victim)
	await bullet_impact.animation_done
	self.queue_free()

# Computes new bullet speed using player orientation and velocity
# Ensures that no bullet is slower than the minimal bullet speed
func set_initial_velocity(shooter_velocity : Vector2, shooter_direction : Vector2, bullet_speed) -> void:
	var new_bullet_velocity = shooter_velocity + bullet_speed * shooter_direction
	# If we cant get a direction from the bullet velocity we use
	# the player_direction as the bullet direction.
	if new_bullet_velocity == Vector2.ZERO:
		new_bullet_velocity = bullet_speed * shooter_direction
	# Making sure no bullet goes slower than the minimal bullet speed
	if new_bullet_velocity.length() < bullet_speed:
		new_bullet_velocity = bullet_speed * new_bullet_velocity.normalized()
	
	velocity = new_bullet_velocity

func _disable_bullet():
	self.collision_layer = 0
	self.collision_mask = 0
	velocity = Vector2.ZERO
	$Sprite.visible = false
