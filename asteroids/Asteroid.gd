extends RigidBody2D

var sprites = [
	preload("res://asteroids/asteroide1.png"),
	preload("res://asteroids/asteroide2.png"),
	preload("res://asteroids/asteroide3.png")
]

@onready var sprite = $SpriteContainer/Sprite
@onready var sprite_container = $SpriteContainer
@onready var animation_player = $AnimationPlayer
@onready var hurt_animation = $HurtAnimation

func _ready():
	sprite.texture = sprites.pick_random()
	
	sprite_container.rotation = randf_range(0, 2*PI)
	animation_player.speed_scale = randf_range(0.2, 2)


func _on_hit_box_body_entered(body):
	var health_system = body.find_child("HealthSystem")
	if health_system != null:
		health_system.on_hit()


func _on_health_system_hp_changed(_health, _max_health):
	hurt_animation.animate_hurt(sprite_container)
