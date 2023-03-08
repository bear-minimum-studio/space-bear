extends CharacterBody2D

class_name AbstractShip

@export_category("Ship properties")
@export_range(0,300,5,"or_greater") var speed : float = 50
@export_range(0.0,50.0,0.1,"or_greater") var rotation_speed : float = 10.0
@export_range(0.0,50.0,0.1,"or_greater") var acceleration : float = 10.0
@export_range(0.0,50.0,0.1,"or_greater") var brake : float = 10.0
@export_range(1.0, 5.0, 0.5) var explosion_scale = 1.0
@export_range(0.0,200.0,1.0,"or_greater") var position_tolerance: float = 5.0
@export var default_behavior_scene: PackedScene
@export var debug_enabled : bool = false

@onready var ship = $Ship
@onready var flammes = $Flammes
@onready var hurt_animation = $HurtAnimation
@onready var health_bar = $UI/HealthBar
@onready var rotation_target: float = rotation

@onready var movement_target: Vector2 = global_position
var behavior : AbstractShipBehavior

var explosion_scene = preload("res://explosion/Explosion.tscn")

func _ready():
	if default_behavior_scene != null:
		set_behavior(default_behavior_scene)
	var turrets = get_node_or_null('Turrets')
	if turrets != null:
		for turret in turrets.get_children():
			turret.init(self)

func _process(_delta):
	if Engine.is_editor_hint():
		return
	queue_redraw()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	_set_rotation_target()
	rotation = lerp_angle(rotation, rotation_target, rotation_speed * delta)
	_set_velocity(delta)
	move_and_slide()

func remove_behavior():
	if behavior != null:
		behavior.free()

func set_behavior(behavior_scene: PackedScene):
	remove_behavior()
	var new_behavior = behavior_scene.instantiate()
	add_child(new_behavior)
	behavior = new_behavior

func _distance_to_target():
	return (global_position - movement_target).length()

func _movement_target_reached():
	return _distance_to_target() < position_tolerance

func _set_rotation_target():
	if movement_target == null:
		return
	
	if _movement_target_reached():
		return
	
	var direction = (movement_target - global_position).normalized()
	rotation_target = direction.angle()

func _set_velocity(delta):
	var curr_speed: float
	if _movement_target_reached():
		curr_speed = lerp(velocity.length(), 0.0, brake * delta)
		flammes.visible = false
	else:
		curr_speed = lerp(velocity.length(), speed, acceleration * delta)
		flammes.visible = true
	velocity = curr_speed * Vector2.from_angle(rotation)

func _on_health_system_dead():
	Events.dead_ship.emit(self)
	_on_dead()

func _on_health_system_hp_changed(_health, _max_health, difference):
	if difference == 0:
		return
	elif difference > 0:
		hurt_animation.animate_heal($Ship)
	else:
		hurt_animation.animate_hurt($Ship)
		Events.ship_hurt.emit(self)

func _draw():
	if debug_enabled:
		# Target speed
		draw_line(Vector2.ZERO, speed * Vector2.RIGHT, Color.DARK_GOLDENROD, 2.0)
		# Target
		draw_line(Vector2.ZERO, (movement_target - global_position).rotated(-global_rotation), Color.CYAN, 2.0)

func _on_dead():
	var new_explosion = explosion_scene.instantiate()

	new_explosion.global_position = self.global_position
	new_explosion.scale = explosion_scale * Vector2.ONE
	WorldReference.current_world.add_child(new_explosion)
