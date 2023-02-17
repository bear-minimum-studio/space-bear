extends CharacterBody2D

var health = 2
var SPEED = 30

var sprites = [
	[preload("res://npc/civilians/vaisseau_civil_1.png"), preload("res://npc/civilians/vaisseau_civil_1_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_2.png"), preload("res://npc/civilians/vaisseau_civil_2_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_3.png"), preload("res://npc/civilians/vaisseau_civil_3_flammes.png")]
]

@onready var ship = $Ship
@onready var flammes = $Flammes

func _ready():
	var ship_and_flammes = sprites.pick_random()
	ship.texture = ship_and_flammes[0]
	flammes.texture = ship_and_flammes[1]

func _physics_process(delta):
	velocity = Vector2(SPEED, 0).rotated(-PI/4.5); # up right
	move_and_slide()

func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()
