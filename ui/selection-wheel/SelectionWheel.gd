extends Control

@export_category("Behavior")
@export var screen_dead_zone: float = 25.0
@export var joystick_deadzone := 0.5

@export_category("Appearance")
@export var color := Color("ffffff", 0.7)
@export var color_hover := Color("ff57c6", 0.7)

@export var antialiasing = false
@export_range(0.0, 500.0, 1.0) var line_length: float = 100.0
@export_range(0.1, 3.0, 0.1) var line_width: float = 1.0
@export_range(1.0, 200.0, 1.0) var button_distance_to_center: float = 75.0

@onready var wheel = $Wheel

# Parameters
var elements
var button_scene

var buttons: Array = []

var selection_angle: float = 0.0
var selecting: bool = false

var mouse_position:
	get: return get_viewport().get_mouse_position()

## direction of left joystick
var joystick_direction:
	get: return Input.get_vector("go_left", "go_right", "go_up", "go_down")

var wheel_center:
	get: return Helpers.get_screen_center(self)

var _rotation_step: float:
	get: return 2 * PI / elements.size()

var selected_index:
	get:
		if !selecting:
			return null
		return floori((selection_angle + PI/2) / _rotation_step)

## Use this to show the wheel
func show_and_init(elements_to_show: Array, button_scene_to_show):
	elements = elements_to_show
	button_scene = button_scene_to_show
	self.show()
	for child in wheel.get_children():
		wheel.remove_child(child)
		child.queue_free()

	_add_buttons()


func _process(_delta):
	if not Engine.is_editor_hint():
		queue_redraw()

	if InputMode.is_mouse():
		selection_angle = (mouse_position - wheel_center).angle()
		selecting = (mouse_position - wheel_center).length() > screen_dead_zone
	else:
		selection_angle = joystick_direction.angle()
		selecting = joystick_direction.length() > joystick_deadzone


func _add_buttons():
	buttons = []
	for i in range(elements.size()):
		var button = button_scene.instantiate()
		wheel.add_child(button)
		_set_button_parameters(button, elements[i])

		var mid_angle = (_button_start_angle(i) + _button_end_angle(i)) / 2
		button.position = wheel_center + button_distance_to_center * Vector2.from_angle(mid_angle)
		buttons.append(button)

func _button_start_angle(i: int) -> float:
	return -PI/2 + i * _rotation_step

func _button_end_angle(i: int) -> float:
	return _button_start_angle(i) +  _rotation_step

func _draw():
	_draw_sectors()
	_draw_deadzone()
	_emphasis()

func _draw_deadzone():
	var circle_color = color_hover
	if selecting:
		circle_color = color
	draw_arc(wheel_center, screen_dead_zone, 0, 2*PI, 100, circle_color, line_width, antialiasing)
	

func _draw_sectors():
	for i in range(buttons.size()):
		var line_angle = _button_start_angle(i)
		var line_start = wheel_center + screen_dead_zone * Vector2.from_angle(line_angle)
		var line_end = wheel_center + line_length * Vector2.from_angle(line_angle)
		draw_line(line_start, line_end, color, line_width, antialiasing)


func _emphasis():
	if selected_index != null:
		var start_angle = _button_start_angle(selected_index)
		var end_angle =  _button_end_angle(selected_index)
		var shifted_center = wheel_center + (line_width / 2) * Vector2.from_angle((start_angle + end_angle) / 2)
		draw_circle_arc_poly(shifted_center, screen_dead_zone, 3*line_length, start_angle, end_angle, color_hover)

func draw_circle_arc_poly(center, min_radius, max_radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	var colors = PackedColorArray([])

	# small arc
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * min_radius)
		colors.push_back(color)
	
	# large arc (in the other direction)
	var transparent_color = color
	transparent_color.a = 0.03
	for i in range(nb_points + 1):
		var angle_point = angle_to + i * (angle_from - angle_to) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * max_radius)
		colors.push_back(transparent_color)
	draw_polygon(points_arc, colors)

func _set_button_parameters(button: Node, element: Dictionary):
	for key in element.keys():
		button.set(key, element[key])
