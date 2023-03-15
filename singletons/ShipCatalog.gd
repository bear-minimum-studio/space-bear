extends Node

var catalog = load("res://ship-upgrades/ShipCatalog.tres")

enum ShipModels {
	CIVILIAN,
	SMALL_TURRET,
	SMALL_SHIELD,
	SMALL_HEAL,
	SHIELD,
	HEAL,
	DOUBLE_TURRET,
}

func _find_ship_in_tree_recursive(ship: AbstractCivilianShip, upgrades_array: Array[ShipCatalogResourceElement]):
	if upgrades_array.size() == 0:
		return null

	for ship_catalog_element in upgrades_array:
		if ship.ship_model == ship_catalog_element.ship_model:
			return ship_catalog_element
		
		var recursively_found_ship_or_null = _find_ship_in_tree_recursive(ship, ship_catalog_element.upgrades)
		if recursively_found_ship_or_null != null:
			return recursively_found_ship_or_null

	return null

func find_ship_in_tree(ship: AbstractCivilianShip):
	return _find_ship_in_tree_recursive(ship, catalog.ships)
