extends Control

@onready var animation_tree = $AnimationTree

@onready var label = $Label
var timer: SceneTreeTimer = null
const DISPLAY_DURATION = 0.5

func _ready():
	Events.ship_hurt.connect(_on_ship_hurt)

func _on_ship_hurt(ship: Node2D):
	if !ship.is_in_group("flock"):
		return
	
	animation_tree["parameters/playback"].travel("Glow")

	if timer == null:
		timer = get_tree().create_timer(DISPLAY_DURATION)
	else:
		timer.time_left = DISPLAY_DURATION
	
	await timer.timeout
	timer = null
	animation_tree["parameters/playback"].travel("Hide")
	
