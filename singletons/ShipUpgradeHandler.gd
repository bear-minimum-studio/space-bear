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


@onready var ship_upgrade_wheel = $SelectionWheel

var saved_mouse_position: Vector2

func _unhandled_input(event):
	if event.is_action_pressed("upgrade"):
		# TODO separate this logic from display
		if not self.is_ship_selected:
			return

		process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		ship_upgrade_wheel.show()
	if event.is_action_released("upgrade"):
		get_tree().paused = false
		process_mode = Node.PROCESS_MODE_INHERIT

		# TODO separate this logic from display
		self.upgrade_candidate = ship_upgrade_wheel.wheel.selection
		ship_upgrade_wheel.hide()

func _on_visibility_changed():
	if visible:
		saved_mouse_position = get_viewport().get_mouse_position()
		Helpers.set_mouse_position(self, Helpers.get_screen_center(self))
		ship_upgrade_wheel.wheel.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		Helpers.set_mouse_position(self, saved_mouse_position)
		ship_upgrade_wheel.wheel.process_mode = Node.PROCESS_MODE_DISABLED
