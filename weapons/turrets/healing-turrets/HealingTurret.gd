extends "res://weapons/turrets/AbstractTurret.gd"

@export var laser_range = 300.0
@export var heal = 5

var laser_scene = preload("res://weapons/projectiles/laser/HealingLaser.tscn")

func _on_shoot():
	var new_laser : Node2D = laser_scene.instantiate()
	new_laser.ready.connect(_init_laser.bind(new_laser))
	WorldReference.current_world.add_child(new_laser)
	
func _init_laser(laser: Node2D):
	laser.init(laser_range, shooter, heal)
	laser.global_rotation = self.global_rotation
	laser.global_position = nozzle.global_position
	laser.shoot()
