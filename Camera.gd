extends Camera2D

@export var focus_zoom_animation_speed = 0.2
@export var focus_zoom_animation_value = 1.5

@onready var initial_zoom = self.zoom
@onready var focus_zoom_animation_relative_value = initial_zoom * focus_zoom_animation_value
@onready var focus_zoom_animation_vector = focus_zoom_animation_relative_value * Vector2.ONE

func _ready():
	Events.closing_ship_upgrades.connect(_on_closing_ship_upgrades)
	Events.opening_ship_upgrades.connect(_on_opening_ship_upgrades)

var do_focus_on_node_animation = false
var selected_focused_node = null

func _process(_delta):
	if not do_focus_on_node_animation:
		return

	var target_offset = selected_focused_node.global_position - (self.get_screen_center_position() - self.offset)

	# TODO is that okay in terms of performance? We're creating a new tween on each frame...
	# It seems fluid but I am quite surprised
	(create_tween()
		.tween_property(self, "offset", target_offset, focus_zoom_animation_speed)
		.set_ease(Tween.EASE_IN_OUT))
	(create_tween()
		.tween_property(self, "zoom", focus_zoom_animation_vector, focus_zoom_animation_speed)
		.set_ease(Tween.EASE_IN_OUT))

func _on_opening_ship_upgrades(ship: Node2D):
	do_focus_animation(ship)

func _on_closing_ship_upgrades():
	do_focus_on_node_animation = false

	(self
		.create_tween()
		.tween_property(self, "offset", Vector2.ZERO, focus_zoom_animation_speed)
		.set_ease(Tween.EASE_IN_OUT))
	(self
		.create_tween()
		.tween_property(self, "zoom", initial_zoom, focus_zoom_animation_speed)
		.set_ease(Tween.EASE_IN_OUT))

func do_focus_animation(node: Node2D):
	do_focus_on_node_animation = true
	selected_focused_node = node
