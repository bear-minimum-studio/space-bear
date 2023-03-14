extends Node

var catalog = load("res://ship-upgrades/ShipCatalog.tres")

enum ShipModels {
	CIVILIAN,
	SMALL_TURRET,
	SMALL_SHIELD,
	SMALL_HEAL,
	SHIELD,
	HEAL
}

func _find_ship_in_tree_recursive(ship: AbstractCivilianShip, upgrades_array: Array[ShipCatalogResourceElement]):
	if upgrades_array.size() == 0:
		return null

	for ship_catalog_element in upgrades_array:
		if ship.ship_type == ship_catalog_element.ship_model:
			return ship_catalog_element
		
		var rec_find = _find_ship_in_tree_recursive(ship, ship_catalog_element.upgrades)
		if rec_find != null:
			return rec_find

	return null

func find_ship_in_tree(ship: AbstractCivilianShip):
	return _find_ship_in_tree_recursive(ship, catalog.ships)
