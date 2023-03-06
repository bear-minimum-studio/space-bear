extends "res://npc/AbstractTurret.gd"

@export var laser_range = 300.0

var laser_scene = preload("res://weapons/projectiles/laser/Laser.tscn")

func _on_shoot():
	var new_laser = laser_scene.instantiate()
	new_laser.laser_range = laser_range
	new_laser.global_rotation = self.global_rotation
	new_laser.global_position = nozzle.global_position
	WorldReference.current_world.add_child(new_laser)
