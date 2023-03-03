extends Node2D

signal nozzle_shoot_grappling_hook

const ROTATION_SPEED = 2.0

const HOOK_COOLDOWN = 1.0

var _reloading_hook = false

@onready var p_2_nozzle = $P2Nozzle

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turret_left", "turret_right")
	self.rotation = self.rotation + rotation_intensity * ROTATION_SPEED * delta
	
	if (Input.is_action_pressed("grappling_hook")):
		_shoot_hook()

func _shoot_hook():
	if _reloading_hook:
		return

	nozzle_shoot_grappling_hook.emit(p_2_nozzle.global_position, self.global_rotation)
	
	_reloading_hook = true
	await get_tree().create_timer(HOOK_COOLDOWN).timeout
	_reloading_hook = false
