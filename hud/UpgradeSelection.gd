extends Control
class_name UpgradeSelection

@onready var label = $VBoxContainer/Label
@onready var resources_count = $VBoxContainer/HBoxContainer/ResourcesCount

var ship_name: String = "":
	set(value):
		ship_name = value
		label.text = ship_name

var cost: int = 0:
	set(value):
		cost = value
		resources_count.amount = cost

