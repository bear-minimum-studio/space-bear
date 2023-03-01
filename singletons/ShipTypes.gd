extends Node

enum ShipTypes {
	SHIELD_SHIP,
	TURRET_SHIP,
}
const _selection = [ShipTypes.SHIELD_SHIP, ShipTypes.TURRET_SHIP]

const ship_names = {
	ShipTypes.SHIELD_SHIP: "ShieldShip",
	ShipTypes.TURRET_SHIP: "TurretShip",
}

const ship_scenes = {
	ShipTypes.SHIELD_SHIP: preload("res://npc/civilians/ShieldShip.tscn"),
	ShipTypes.TURRET_SHIP: preload("res://npc/civilians/TurretShip.tscn"),
}

var _current_selection = 0

func _get_current_selection():
	return _selection[_current_selection]

func select_next_ship():
	_current_selection += 1 
	_current_selection = _current_selection % _selection.size()

func get_current_ship_name():
	return ship_names[_get_current_selection()]

func get_current_ship_scene():
	return ship_scenes[_get_current_selection()]
