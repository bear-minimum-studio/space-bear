extends "res://npc/enemies/AbstractEnemy.gd"

# TODO this whole script is copy pasted for each enemy

@export_range(0.0,2.0,0.05,"or_greater") var proximity_ratio = 0.7

@onready var _turret_range = $Turrets/AutoBulltetTurret.turret_range

func _ready():
	super._ready()
	behavior.distance_to_target = proximity_ratio * _turret_range
