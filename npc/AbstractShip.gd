extends CharacterBody2D

@export_category("Ship properties")
@export_range(0,300,5,"or_greater") var speed : float = 50
@export_range(0.0,50.0,0.1,"or_greater") var rotation_speed : float = 10.0

@onready var ship = $Ship
@onready var flammes = $Flammes
@onready var nav_agent = $NavigationAgent2D
@onready var hurt_animation = $HurtAnimation

var _next_path_position : Vector2
var _current_agent_position : Vector2

var movement_target: Vector2

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		return

	_next_path_position = nav_agent.get_next_path_position()
	_current_agent_position = global_transform.origin
	velocity = (_next_path_position - _current_agent_position).normalized() * speed
	self.rotation = velocity.angle()
	move_and_slide()

func set_movement_target(new_movement_target : Vector2):
	movement_target = new_movement_target
	nav_agent.set_target_position(movement_target)


func _on_health_system_dead():
	Events.dead_ship.emit(self)

func _on_health_system_hp_changed(_health, _max_health):
	hurt_animation.animate_hurt($Ship)
	Events.ship_hurt.emit(self)
