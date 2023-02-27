extends "res://npc/AbstractShip.gd"

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
	[preload("res://npc/civilians/vaisseau_civil_3.png"), preload("res://npc/civilians/vaisseau_civil_3_flammes.png")]
]

func _ready():
	var ship_and_flammes = sprites.pick_random()
	ship.texture = ship_and_flammes[0]
	flammes.texture = ship_and_flammes[1]

func select():
	selected = true

func unselect():
	selected = false
