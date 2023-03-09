extends Node

const MOUSE = 0
const CONTROLLER = 1

var source = MOUSE:
	set(value):
		source = value
		if value == MOUSE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if value == CONTROLLER:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func is_mouse() -> bool:
	return source == MOUSE

func is_controller() -> bool:
	return source == CONTROLLER

func use_mouse():
	source = MOUSE

func use_controller():
	source = CONTROLLER
