extends CharacterBody2D

@export_category("Ship properties")
@export_range(0,300,5,"or_greater") var speed : float = 50
@export_range(0.0,50.0,0.1,"or_greater") var rotation_speed : float = 10.0
@export_range(0.0,50.0,0.1,"or_greater") var acceleration : float = 10.0
@export_range(0.0,50.0,0.1,"or_greater") var brake : float = 10.0

@onready var ship = $Ship
@onready var flammes = $Flammes
@onready var nav_agent = $NavigationAgent2D
@onready var hurt_animation = $HurtAnimation
@onready var health_bar = $UI/HealthBar

@onready var rotation_target: float = rotation

var movement_target: Vector2

func _ready():
	if $Turrets != null:
		var turrets = $Turrets.get_children()
		for turret in turrets:
			turret.init(self)

func _physics_process(delta):
	_set_rotation_target()
	rotation = lerp_angle(rotation, rotation_target, rotation_speed * delta)
	_set_velocity(delta)
	move_and_slide()
	if(nav_agent.debug_enabled):
		queue_redraw()

func _set_rotation_target():
	if nav_agent.is_navigation_finished():
		return
		
	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	rotation_target = direction.angle()

func _set_velocity(delta):
	var curr_speed: float
	if nav_agent.is_navigation_finished():
		curr_speed = lerp(velocity.length(), 0.0, brake * delta)
		flammes.visible = false
	else:
		curr_speed = lerp(velocity.length(), speed, acceleration * delta)
		flammes.visible = true
	velocity = curr_speed * Vector2.from_angle(rotation)

func set_movement_target(new_movement_target : Vector2):
	movement_target = new_movement_target
	nav_agent.set_target_position(movement_target)

func _on_health_system_dead():
	Events.dead_ship.emit(self)

func _on_health_system_hp_changed(_health, _max_health):
	hurt_animation.animate_hurt($Ship)
	Events.ship_hurt.emit(self)

func _draw():
	if(nav_agent.debug_enabled):
		# Target speed
		draw_line(Vector2.ZERO, speed * Vector2.RIGHT, Color.DARK_GOLDENROD, 2.0)
		# Target
		draw_line(Vector2.ZERO, (movement_target - global_position).rotated(-global_rotation), Color.CYAN, 2.0)
