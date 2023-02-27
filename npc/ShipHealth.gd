extends TextureProgressBar

@export var health_system: HealthSystem

var timer: SceneTreeTimer = null
const DISPLAY_DURATION = 2

func _ready():
	self.visible = false
	health_system.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(health, max_health):
	self.visible = true
	self.max_value = max_health
	self.value = health

	if timer == null:
		timer = get_tree().create_timer(DISPLAY_DURATION)
	else:
		timer.time_left = DISPLAY_DURATION
	
	await timer.timeout
	timer = null
	self.visible = false
