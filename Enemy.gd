extends CharacterBody2D

var health = 10

var sprites = [
	preload("res://asteroids/asteroide1.png"),
	preload("res://asteroids/asteroide2.png"),
	preload("res://asteroids/asteroide3.png")
]
@onready var sprite = $Sprite

func _ready():
	var rand_index = randi() % sprites.size()
	sprite.texture = sprites[rand_index]

func on_hit():
	health -= 1

	if (health <= 0):
		self.queue_free()
