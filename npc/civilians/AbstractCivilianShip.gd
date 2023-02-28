extends "res://npc/AbstractShip.gd"
class_name AbstractCivilianShip

@export_range(0,10000,1,"or_greater") var number_of_passengers = 0;

func set_convoy_path(target_position: Vector2, mothership_position: Vector2):
	# all allies should aim to reach the wormhole while keeping their relative position
	# the allies behind the mothership have a longer way to go
	var mothership_trajectory = target_position - mothership_position
	var direction = mothership_trajectory / mothership_trajectory.length()
	var additional_trajectory = (mothership_position - self.global_position).project(direction)
	var trajectory = mothership_trajectory + additional_trajectory
	set_movement_target(self.global_position + trajectory)
