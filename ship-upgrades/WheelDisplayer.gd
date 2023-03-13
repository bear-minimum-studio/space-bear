extends Control

@export_range(0.0, 1000.0, 10.0) var ms_time_before_selection = 300.0
@onready var ship_upgrade_wheel = $SelectionWheel

var saved_mouse_position: Vector2

var _enabled
var _elements
 
var _enough_time_elapsed = false

signal upgrade_selected

signal opening_upgrades
signal closing_upgrades

var opened = false

func _input(event):
	if event.is_action_pressed("upgrade"):
		show_wheel()
		return

	if event.is_action_released("upgrade"):
		dismiss(false)
		return

func _start_timer():
	_enough_time_elapsed = false
	await self.get_tree().create_timer(ms_time_before_selection / 1000, true, false, true).timeout
	_enough_time_elapsed = true

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

func enable():
	_enabled = true

func disable():
	_enabled = false

func set_elements(new_elements):
	_elements = new_elements

func show_wheel():
	if opened:
		return

	if not _enabled:
		return

	_start_timer()
	Engine.time_scale = 0.1
	ship_upgrade_wheel.show_and_init(_elements)
	opened = true
	
	self.opening_upgrades.emit()

func dismiss(force_dismiss = false):
	if not opened:
		return

	Engine.time_scale = 1.0
	if not force_dismiss and ship_upgrade_wheel.selected != null:
		if _enough_time_elapsed:
			self.upgrade_selected.emit(ship_upgrade_wheel.selected)

	ship_upgrade_wheel.hide()
	opened = false
	self.closing_upgrades.emit()
