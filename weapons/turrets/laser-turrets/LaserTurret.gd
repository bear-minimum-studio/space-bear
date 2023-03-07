extends "res://weapons/turrets/AbstractTurret.gd"

@export var laser_range = 300.0
@export_range(1, 30) var damage = 1

var laser_scene = preload("res://weapons/projectiles/laser/Laser.tscn")

func _on_shoot():
	var new_laser = laser_scene.instantiate()
	new_laser.init(laser_range, shooter, damage)
	new_laser.global_rotation = self.global_rotation
	new_laser.global_position = nozzle.global_position
	WorldReference.current_world.add_child(new_laser)
