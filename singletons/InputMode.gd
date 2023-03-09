extends Node

const MOUSE = 0
const CONTROLLER = 1

var current_mode = CONTROLLER

func is_mouse() -> bool:
	return current_mode == MOUSE

func is_controller() -> bool:
	return current_mode == CONTROLLER
