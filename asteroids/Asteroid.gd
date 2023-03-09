extends RigidBody2D

@export_range(1, 100, 1) var kill_bonus = 10

var sprites = [
	{
		"base": preload("res://asteroids/asteroide1.png"),
		"minerals": preload("res://asteroids/asteroide_minerais1.png")
	},
	{
		"base": preload("res://asteroids/asteroide2.png"),
		"minerals": preload("res://asteroids/asteroide_minerais2.png")
	},
	{
		"base": preload("res://asteroids/asteroide3.png"),
		"minerals": preload("res://asteroids/asteroide_minerais3.png")
	},
]

@onready var sprite = $SpriteContainer/Sprite
@onready var sprite_container = $SpriteContainer
@onready var animation_player = $AnimationPlayer
@onready var hurt_animation = $HurtAnimation
@onready var minerals = $SpriteContainer/Minerals
@onready var mineral_particles = $MineralParticles

var bonus_resources_scene = preload("res://hud/BonusResources.tscn")

func _ready():
	var random_asteroid_sprite = sprites.pick_random()
	sprite.texture = random_asteroid_sprite.base
	minerals.texture = random_asteroid_sprite.minerals
	
	sprite_container.rotation = randf_range(0, 2*PI)
	animation_player.speed_scale = randf_range(0.2, 2)


func _on_health_system_hp_changed(_health, _max_health, _difference):
	hurt_animation.animate_hurt(sprite_container)


func _on_health_system_dead():
	minerals.texture = null
	collision_layer = 0
	collision_mask = 0

	FlockResources.earn_resources(kill_bonus)
	
	var bonus_resources = bonus_resources_scene.instantiate()
	bonus_resources.init(kill_bonus)
	bonus_resources.global_position = self.global_position
	WorldReference.current_world.add_child(bonus_resources)
	mineral_particles.emitting = true
