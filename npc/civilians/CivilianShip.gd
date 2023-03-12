extends "res://npc/civilians/AbstractCivilianShip.gd"

var contour_material = preload("res://ContourMaterial.tres")

var selected = false :
	set(new_value):
		selected = new_value
		if (selected):
			self.material = contour_material
			self.health_bar.force_visibility(true)
		else:
			self.material = null
			self.health_bar.force_visibility(false)

var sprites = [
	[preload("res://npc/civilians/vaisseau_civil_1.png"), preload("res://npc/civilians/vaisseau_civil_1_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_2.png"), preload("res://npc/civilians/vaisseau_civil_2_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_3.png"), preload("res://npc/civilians/vaisseau_civil_3_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_4.png"), preload("res://npc/civilians/vaisseau_civil_4_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_5.png"), preload("res://npc/civilians/vaisseau_civil_5_flammes.png")],
	[preload("res://npc/civilians/vaisseau_civil_6.png"), preload("res://npc/civilians/vaisseau_civil_6_flammes.png")],
]

func _ready():
	super._ready()
	var ship_and_flammes = sprites.pick_random()
	ship.texture = ship_and_flammes[0]
	flammes.texture = ship_and_flammes[1]

func select():
	selected = true

func unselect():
	selected = false

var behavior_before_following
var speed_before_following
var squadron_behavior = preload("res://npc/ship-behaviors/squadron/SquadronShipBehavior.tscn")
var follow_target_behavior = preload("res://npc/ship-behaviors/squadron/squadron-behaviors/TargetSquadronBehavior.tscn")

func _set_follow_behavior(target: Node2D):
	if not behavior is SquadronShipBehavior:
		behavior_before_following = behavior
		remove_child(self.behavior)
		behavior = null
		set_behavior(squadron_behavior.instantiate())
	behavior.add_to_squadron('follow%s' % target.name)
	behavior.squadron.set_behavior(follow_target_behavior)
	behavior.squadron.behavior.target = target
	behavior.squadron.behavior.distance_to_target = 150.0

func _follow_target(target: Node2D):
	speed_before_following = self.speed
	if not behavior is SquadronShipBehavior:
		_set_follow_behavior(target)
	self.speed = self.speed * 3

func switch_follow_target(target: Node2D):
	if behavior is SquadronShipBehavior and behavior.squadron.behavior.target == target:
		set_behavior(behavior_before_following)
		self.speed = speed_before_following
	else:
		_follow_target(target)
