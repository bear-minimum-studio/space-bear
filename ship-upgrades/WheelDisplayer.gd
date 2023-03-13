extends Control

@onready var ship_upgrade_wheel = $SelectionWheel

var saved_mouse_position: Vector2

func _unhandled_input(event):
	if event.is_action_pressed("upgrade"):
		# TODO separate this logic from display
		if not get_parent().is_ship_selected:
			return

		process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		var elements = ShipCatalog.catalog.ships.map(func (element):
			return {
				"parameters": {
					"cost": element.price,
					"ship_name": element.display_name
				},
			}
		)
		ship_upgrade_wheel.show_and_init(elements)

	if event.is_action_released("upgrade"):
		get_tree().paused = false
		process_mode = Node.PROCESS_MODE_INHERIT

		# TODO separate this logic from display
		if ship_upgrade_wheel.selected_index != null:
			get_parent().upgrade_candidate = ShipCatalog.catalog.ships[ship_upgrade_wheel.selected_index]
		else:
			get_parent().upgrade_candidate = null
		ship_upgrade_wheel.hide()

## Moves the mouse cursor to the center of the screen
## and puts it back to the original position after wheel is closed
func _on_visibility_changed():
	if ship_upgrade_wheel.visible:
		saved_mouse_position = get_viewport().get_mouse_position()
		Helpers.set_mouse_position(self, Helpers.get_screen_center(self))
		ship_upgrade_wheel.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		Helpers.set_mouse_position(self, saved_mouse_position)
		ship_upgrade_wheel.process_mode = Node.PROCESS_MODE_DISABLED
