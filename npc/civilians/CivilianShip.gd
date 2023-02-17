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
@onready var nav_agent = $NavigationAgent2D

func _ready():
	var ship_and_flammes = sprites.pick_random()
	ship.texture = ship_and_flammes[0]
	flammes.texture = ship_and_flammes[1]


func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return

	var next_path_position : Vector2 = nav_agent.get_next_path_position()
	var current_agent_position : Vector2 = global_transform.origin
	var new_velocity : Vector2 = (next_path_position - current_agent_position).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()


func set_movement_target(movement_target : Vector2):
	nav_agent.set_target_position(movement_target)


func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()

