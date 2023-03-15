extends "res://weapons/turrets/AbstractTurret.gd"

@export var laser_range = 300.0
@export_range(1, 30) var damage = 1

var laser_scene = preload("res://weapons/projectiles/laser/Laser.tscn")

func _on_shoot():
	var new_laser = laser_scene.instantiate()
	new_laser.ready.connect(_init_laser.bind(new_laser))
	WorldReference.current_world.add_child(new_laser)
	
func _init_laser(laser: Node2D):
	laser.init(laser_range, shooter, damage)
	laser.global_rotation = self.global_rotation
	laser.global_position = nozzle.global_position
	laser.shoot()
