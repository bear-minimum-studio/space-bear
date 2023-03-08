extends "res://npc/civilians/AbstractCivilianShip.gd"

var contour_material = preload("res://ContourMaterial.tres")

var target_offset = Vector2.ZERO
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

var followed_ship: Node2D = null
var target_before_following
var speed_before_following

func follow_player(player: Node2D):
	if followed_ship == null:
		target_before_following = self.movement_target
		speed_before_following = self.speed
		followed_ship = player
		self.speed = self.speed * 3
	else:
		followed_ship = null
		movement_target = target_before_following
		self.speed = speed_before_following

func _physics_process(_delta):
	super._physics_process(_delta)

	if followed_ship == null:
		return

	movement_target = followed_ship.global_position
