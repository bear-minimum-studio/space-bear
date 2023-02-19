extends CharacterBody2D

@export_category("Ship properties")
@export_range(0,300,5,"or_greater") var SPEED : float = 50
@export_range(0.0,50.0,0.1,"or_greater") var ROTATION_SPEED : float = 10.0

@onready var ship = $Ship
@onready var flammes = $Flammes
@onready var nav_agent = $NavigationAgent2D
@onready var avoidance_circle = $AvoidanceCircle

var _next_path_position : Vector2
var _current_agent_position : Vector2
var _new_velocity : Vector2

func _ready():
	assert(avoidance_circle.shape is CircleShape2D, 'Define AvoidanceCircle for navigation')
	nav_agent.radius = avoidance_circle.shape.radius * max(self.scale.x, self.scale.y)

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return

	_next_path_position = nav_agent.get_next_path_position()
	_current_agent_position = global_transform.origin
	_new_velocity = (_next_path_position - _current_agent_position).normalized() * SPEED
	nav_agent.set_velocity(_new_velocity)

func set_movement_target(movement_target : Vector2):
	nav_agent.set_target_position(movement_target)

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	self.rotation = lerp_angle(self.rotation, velocity.angle(), ROTATION_SPEED * get_physics_process_delta_time())

