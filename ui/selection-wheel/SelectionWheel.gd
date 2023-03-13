extends Control

# TODO this script will go into the parent

@onready var wheel = $Wheel

var saved_mouse_position: Vector2

func _unhandled_input(event):
	if event.is_action_pressed("upgrade"):
		# TODO get rid of this coupling
		if not get_parent().is_ship_selected:
			return
		process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		self.show()
	if event.is_action_released("upgrade"):
		get_tree().paused = false
		process_mode = Node.PROCESS_MODE_INHERIT
		# TODO get rid of this coupling
		get_parent().upgrade_candidate = wheel.selection
		self.hide()

func _on_visibility_changed():
	if visible:
		saved_mouse_position = get_viewport().get_mouse_position()
		Helpers.set_mouse_position(self, Helpers.get_screen_center(self))
		wheel.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		Helpers.set_mouse_position(self, saved_mouse_position)
		wheel.process_mode = Node.PROCESS_MODE_DISABLED
