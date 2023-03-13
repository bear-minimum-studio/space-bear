extends Node2D

## set by Player/Selection_Zone
var selected_ship

## set by Game/SelectionWheel
var upgrade_candidate: ShipCatalogResourceElement:
	set(value):
		upgrade_candidate = value
		upgrade(selected_ship)

var is_ship_selected:
	get: return selected_ship != null


func upgrade(ship):
	if upgrade_candidate == null:
		return
	if selected_ship == null:
		return
	
	var price = upgrade_candidate.price
	if FlockResources.get_resources() < price:
		return
	FlockResources.spend_resource(price)
	
	if ship.has_method("upgrade"):
		ship.upgrade(upgrade_candidate)
