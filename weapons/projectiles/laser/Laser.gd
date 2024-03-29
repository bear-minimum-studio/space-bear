extends Node2D

@onready var line_2d = $Line2D
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer
@onready var long_particles = $LongParticles
@onready var impact_particles = $ImpactParticles

var shooter: Node2D

@export var damage_or_heal = 1

@export var laser_range: float:
	set(new_range):
		if new_range == null or laser_range == new_range:
			return
		laser_range = new_range
		_update_sprite_length(laser_range)
		_update_raycast_range(laser_range)
		_update_particles_length(laser_range)

func init(laser_range_init: float, shooter_init: Node2D, damage_or_heal_init: int):
	self.laser_range = laser_range_init
	self.shooter = shooter_init
	self.damage_or_heal = damage_or_heal_init

func shoot():
	_update_raycast_range(laser_range)

	ray_cast_2d.add_exception(self.shooter)

	ray_cast_2d.force_raycast_update()
	var coll = ray_cast_2d.get_collision_point()
	var distance
	if coll == Vector2.ZERO:
		distance = laser_range
		impact_particles.visible = false
	else:
		var body_or_area = ray_cast_2d.get_collider()
		_hit(body_or_area)
		distance = (coll - global_position).length()
	
	_update_sprite_length(distance)
	_update_particles_length(distance)
	
	await animation_player.animation_finished
	self.queue_free()

func _update_raycast_range(length: float):
	if ray_cast_2d == null:
		printerr("Laser has no RayCast2D.")
		return

	ray_cast_2d.target_position = length * Vector2.RIGHT

func _update_sprite_length(length: float):
	if line_2d == null:
		printerr("Laser has no Line2D.")
		return

	var last_point_index = line_2d.get_point_count() - 1
	line_2d.set_point_position(last_point_index, length * Vector2.RIGHT)

func _update_particles_length(length: float):
	if long_particles != null:
		var em: ParticleProcessMaterial = long_particles.process_material
		em.emission_box_extents.x = length / 2

		long_particles.transform.origin = Vector2.RIGHT * length / 2

	if impact_particles != null:
		impact_particles.transform.origin = Vector2.RIGHT * length

func _hit(area_or_body):
	HealthSystem.hit_health_system(area_or_body, damage_or_heal)
