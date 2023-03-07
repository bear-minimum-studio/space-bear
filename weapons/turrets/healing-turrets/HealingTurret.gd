extends "res://weapons/turrets/AbstractTurret.gd"

@export var laser_range = 300.0
@export var heal = 5

var laser_scene = preload("res://weapons/projectiles/laser/HealingLaser.tscn")

func _on_shoot():
	var new_laser = laser_scene.instantiate()
	new_laser.init(laser_range, shooter, heal)
	new_laser.global_rotation = self.global_rotation
	new_laser.global_position = nozzle.global_position
	WorldReference.current_world.add_child(new_laser)
