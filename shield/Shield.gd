@tool
extends Area2D
class_name Shield

const COLLISION_MARGIN = 10

@onready var collision_shape_2d = $CollisionShape2D
@onready var health_system = $HealthSystem
@onready var old_collision_layer = collision_layer
@export_range(1.0, 30.0) var recharge_delay_seconds = 5.0
@onready var sprite_2d = $Sprite2D

@export var max_health = 20 :
	set(new_max_health):
		max_health = new_max_health
		_initialize_max_health()

@export_color_no_alpha var shield_color: Color = Color("#0096ff") :
	set(new_color):
		shield_color = new_color
		_update_shield_color()

@export var shield_size: float = 100.0 :
	set(new_shield_size):
		shield_size = new_shield_size
		_update_shield_size()


var timer_before_heal: SceneTreeTimer = null

func _ready():
	_update_shield_size()
	_update_shield_color()
	if Engine.is_editor_hint():
		return
	health_system.hp_changed.connect(_on_hit)
	health_system.dead.connect(_on_dead)
	_initialize_max_health()

func _update_shield_color():
	if sprite_2d != null:
		sprite_2d.material.set_shader_parameter('color', shield_color)

func _on_hit(_health, _max_health):
	if timer_before_heal == null:
		timer_before_heal = self.get_tree().create_timer(recharge_delay_seconds)
		await timer_before_heal.timeout
		timer_before_heal = null
		health_system.heal_to_max()
	else:
		timer_before_heal.time_left = recharge_delay_seconds

	var hit_increase = 0.17
	var current_intensity = sprite_2d.material.get_shader_parameter('hit_intensity');
	var hit_intensity = min(1.0,current_intensity+hit_increase)
	var tween_health = create_tween()
	tween_health.tween_property(sprite_2d, "material:shader_parameter/hit_intensity",hit_intensity,0.1)
	tween_health.tween_property(sprite_2d, "material:shader_parameter/hit_intensity",0.0,0.3)
	
	var health_amount = (_health / float(_max_health))
	var tween_hit = create_tween()
	tween_hit.tween_property(sprite_2d, "material:shader_parameter/opacity",health_amount,0.05)


func _update_shield_size():
	if collision_shape_2d != null:
		collision_shape_2d.shape.radius = shield_size + COLLISION_MARGIN
	if sprite_2d != null:
		var sprite_scale = shield_size / 100.0 # TODO: use default size instead (100 right now)
		sprite_2d.apply_scale(Vector2(sprite_scale,sprite_scale))

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
