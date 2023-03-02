@tool
extends Area2D
class_name Shield

const COLLISION_MARGIN = 10

@onready var collision_shape_2d = $CollisionShape2D
@onready var hurt_animation = $HurtAnimation
@onready var health_system = $HealthSystem
@onready var old_collision_layer = collision_layer
@export_range(1.0, 30.0) var recharge_delay_seconds = 5.0

@export var max_health = 20 :
	set(new_max_health):
		max_health = new_max_health
		_initialize_max_health()

@export var shield_color: Color = Color("#0096ff2b") :
	set(new_color):
		shield_color = new_color
		queue_redraw()

@export var shield_outline: Color = Color("#0974ad") :
	set(new_color):
		shield_outline = new_color
		queue_redraw()

@export var shield_size: float = 100.0 :
	set(new_shield_size):
		shield_size = new_shield_size
		_update_collision_shape_margin()
		queue_redraw()

@export var outline_width: float = 2.0 :
	set(new_outline_width):
		outline_width = new_outline_width
		queue_redraw()

var timer_before_heal: SceneTreeTimer = null

func _ready():
	_update_collision_shape_margin()
	if Engine.is_editor_hint():
		return
	health_system.hp_changed.connect(_on_hit)
	health_system.dead.connect(_on_dead)
	_initialize_max_health()

func _draw():
	draw_circle(Vector2.ZERO, shield_size, shield_color)
	draw_arc(Vector2.ZERO, shield_size, 0, 2 * PI, 50, shield_outline, outline_width, false)

func _on_hit(_health, _max_health):
	hurt_animation.animate_hurt_opacity(self)
	
	if timer_before_heal == null:
		timer_before_heal = self.get_tree().create_timer(recharge_delay_seconds)
		await timer_before_heal.timeout
		timer_before_heal = null
		health_system.heal_to_max()
		return
	else:
		timer_before_heal.time_left = recharge_delay_seconds

func _update_collision_shape_margin():
	if collision_shape_2d != null:
		collision_shape_2d.shape.radius = shield_size + COLLISION_MARGIN

func _initialize_max_health():
	if health_system != null:
		health_system.max_health = max_health

func _on_dead():
	_toggle_shield(false)
	await get_tree().create_timer(recharge_delay_seconds).timeout
	_toggle_shield(true)

	health_system.heal_to_max()

func _toggle_shield(is_enabled: bool):
	if is_enabled:
		self.visible = true
		self.collision_layer = old_collision_layer
	else:
		self.visible = false
		self.collision_layer = 0
