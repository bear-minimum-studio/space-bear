extends CharacterBody2D

var sprites = [
	[preload("res://npc/civilians/vaisseau_civil_1.png"), preload("res://npc/civilians/vaisseau_civil_1_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_2.png"), preload("res://npc/civilians/vaisseau_civil_2_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_3.png"), preload("res://npc/civilians/vaisseau_civil_3_flammes.png")]
]

var health = 2
var SPEED = 50

@onready var sprite = $Sprite
@onready var ship = $Sprite/Ship
@onready var flammes = $Sprite/Flammes
@onready var nav_agent = $NavigationAgent2D

var target_offset = Vector2.ZERO


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
	nav_agent.set_velocity(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	self.rotation = lerp_angle(self.rotation, velocity.angle()+PI/2, 10.0*get_physics_process_delta_time())

func set_target_offset(initial_target_position):
	target_offset = initial_target_position - self.global_transform.origin

func set_movement_target(movement_target : Vector2):
	nav_agent.set_target_position(movement_target - target_offset)


func on_hit():
	if health > 0:
		health -= 1
	if health <= 0:
		self.queue_free()
