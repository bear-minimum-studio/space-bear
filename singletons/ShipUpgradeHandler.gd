extends Control

## set by Player/Selection_Zone
var selected_ship

## set by Game/SelectionWheel
var upgrade_candidate: ShipCatalogResourceElement:
	set(value):
		upgrade_candidate = value
		_upgrade(selected_ship)

var is_ship_selected:
	get: return selected_ship != null

func _ready():
	Events.selected_ship_changed.connect(_on_selected_ship_changed)

func _upgrade(ship):
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

func _on_selected_ship_changed(new_ship):
	selected_ship = new_ship
