extends "res://npc/enemies/AbstractEnemy.gd"

@export_range(0.0,2.0,0.05,"or_greater") var proximity_ratio = 0.7

@onready var _turret_range = $Turrets/Turret.turret_range

func _ready():
	super._ready()
	$Behavior.distance_to_target = proximity_ratio * _turret_range
