extends CharacterBody2D

var health = 10

var sprites = [
	preload("res://asteroids/asteroide1.png"),
	preload("res://asteroids/asteroide2.png"),
	preload("res://asteroids/asteroide3.png")
]

@onready var sprite = $SpriteContainer/Sprite
@onready var sprite_container = $SpriteContainer
@onready var animation_player = $AnimationPlayer

func _ready():
	var rand_index = randi() % sprites.size()
	sprite.texture = sprites[rand_index]
	
	sprite_container.rotation = randf_range(0, 2*PI)
	animation_player.speed_scale = randf_range(0.2, 2)

func on_hit():
	health -= 1

	if (health <= 0):
		self.queue_free()
