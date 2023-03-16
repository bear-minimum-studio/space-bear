extends Control

@onready var animation_player = $AnimationPlayer

@export_range(0.0, 1.0, 0.1) var health_percentage_before_appearing = 0.7
@export_range(1.0, 4.0, 0.1) var max_blinking_speed_scale = 2.0
@export_range(0.0, 1.0, 0.1) var min_alpha_level = 0.3

func _ready():
	Events.player_hp_changed.connect(_on_hp_changed)
	self.visible = false
	
func _on_hp_changed(health, max_health):
	var health_percentage = float(health) / float(max_health)
	if health_percentage > health_percentage_before_appearing:
		self.visible = false
		return
	
	self.visible = true

	# If percentage_relative_to_appearance is 100% -> value is min_alpha_level
	# If percentage_relative_to_appearance is 0% -> value is 1.0
	var percentage_relative_to_appearance = health_percentage / health_percentage_before_appearing
	self.modulate.a = 1 - (percentage_relative_to_appearance * (1.0 - min_alpha_level))

	# If percentage_relative_to_appearance is 100% -> value is 1.0
	# If percentage_relative_to_appearance is 0% -> value is max_blinking_speed_scale
	var speed_scale = max_blinking_speed_scale - (percentage_relative_to_appearance * (max_blinking_speed_scale - 1.0))
	animation_player.speed_scale = speed_scale
