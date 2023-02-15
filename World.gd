extends Node2D

@onready var player = $Player

var bullet_scene = preload("res://Bullet.tscn")

func _on_player_shoot(global_player_position, global_player_rotation):
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = global_player_position
	new_bullet.global_rotation = global_player_rotation
	self.add_child(new_bullet)
