extends Control

@onready var label = $Label
var timer: SceneTreeTimer = null
const DISPLAY_DURATION = 2

func _ready():
	label.visible = false
	Events.ship_hurt.connect(_on_ship_hurt)

func _on_ship_hurt(ship: Node2D):
	if !ship.is_in_group("flock"):
		return
	
	label.visible = true

	if timer == null:
		timer = get_tree().create_timer(DISPLAY_DURATION)
	else:
		timer.time_left = DISPLAY_DURATION
	
	await timer.timeout
	timer = null
	label.visible = false
	
