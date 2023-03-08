extends "res://npc/enemies/AbstractEnemy.gd"

@export_range(0.0,2.0,0.05,"or_greater") var proximity_ratio = 0.7

@onready var _turret_range = $Turrets/AutoBulltetTurret.turret_range
@onready var behavior : ProximityBehavior = $ProximityBehavior

func _ready():
	super._ready()
	behavior.distance_to_target = proximity_ratio * _turret_range
