extends RigidBody2D

var health = 11 # self hits once at creation

var sprites = [
	preload("res://asteroids/asteroide1.png"),
	preload("res://asteroids/asteroide2.png"),
	preload("res://asteroids/asteroide3.png")
]

@onready var sprite = $SpriteContainer/Sprite
@onready var sprite_container = $SpriteContainer
@onready var animation_player = $AnimationPlayer

func _ready():
	sprite.texture = sprites.pick_random()
	
	sprite_container.rotation = randf_range(0, 2*PI)
	animation_player.speed_scale = randf_range(0.2, 2)

func on_hit():
	health -= 1

	if (health <= 0):
		self.queue_free()


func _on_hit_box_body_entered(body):
	if body.has_method("on_hit"):
		body.on_hit()
