extends "res://npc/AbstractTurret.gd"

@export var range = 300.0

var laser_scene = preload("res://weapons/laser/Laser.tscn")

func _on_shoot():
	var new_laser = laser_scene.instantiate()
	new_laser.range = range
	new_laser.global_rotation = self.global_rotation
	new_laser.global_position = self.global_position
	WorldReference.current_world.add_child(new_laser)
