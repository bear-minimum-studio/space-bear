extends "res://npc/AbstractShip.gd"

var health = 2
var target_offset = Vector2.ZERO

var sprites = [
	[preload("res://npc/civilians/vaisseau_civil_1.png"), preload("res://npc/civilians/vaisseau_civil_1_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_2.png"), preload("res://npc/civilians/vaisseau_civil_2_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_3.png"), preload("res://npc/civilians/vaisseau_civil_3_flammes.png")]
]


func _ready():
	super._ready()
	var ship_and_flammes = sprites.pick_random()
	ship.texture = ship_and_flammes[0]
	flammes.texture = ship_and_flammes[1]


func set_target_offset(initial_target_position):
	target_offset = initial_target_position - self.global_transform.origin

func set_movement_target(movement_target : Vector2):
	nav_agent.set_target_position(movement_target - target_offset)

func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()
