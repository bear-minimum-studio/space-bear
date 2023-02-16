extends Node2D

const ROTATION_SPEED = 0.04

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turret_left", "turret_right")
	self.rotation = self.rotation + rotation_intensity * ROTATION_SPEED
