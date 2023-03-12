extends RigidBody2D

@export var has_resources = true
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
	
	if not has_resources:
		_remove_resources()


func _on_health_system_hp_changed(_health, _max_health, _difference):
	hurt_animation.animate_hurt(sprite_container)


func _on_health_system_dead():
	_remove_resources()
	FlockResources.earn_resources(kill_bonus)

	var bonus_resources = bonus_resources_scene.instantiate()
	bonus_resources.init(kill_bonus)
	bonus_resources.global_position = self.global_position
	WorldReference.current_world.add_child(bonus_resources)
	mineral_particles.emitting = true

func _remove_resources():
	minerals.texture = null
	collision_layer = 0
	collision_mask = 0
	has_resources = false
	self.remove_from_group("resources-deposit")
