extends TextureProgressBar

@export var health_system: HealthSystem

var timer: SceneTreeTimer = null
const DISPLAY_DURATION = 2
const ANIMATION_IN_DURATION = 0.2
const ANIMATION_OUT_DURATION = 1

func show_temporarily():
	_toggle_visibility(true)
	if timer == null:
		timer = get_tree().create_timer(DISPLAY_DURATION)
	else:
		timer.time_left = DISPLAY_DURATION
	
	await timer.timeout
	timer = null
	_toggle_visibility(false)

func force_visibility(new_visibility: bool):
	_toggle_visibility(new_visibility, true)

func _ready():
	_toggle_visibility(false, true)
	health_system.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(health, max_health, _difference):
	self.max_value = max_health
	self.value = health
	show_temporarily()

func _toggle_visibility(new_visibility: bool, disable_animation = false):
	if disable_animation:
		self.modulate.a = 1 if new_visibility == true else 0
		return

	if new_visibility == true:
		create_tween().tween_property(self, "modulate:a", 1, ANIMATION_IN_DURATION)
	else:
		create_tween().tween_property(self, "modulate:a", 0, ANIMATION_OUT_DURATION)
