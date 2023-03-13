extends Camera2D

@export var upgrade_zoom_speed = 0.2
@export var upgrade_zoom_value = 1.5

@onready var initial_zoom = self.zoom
@onready var upgrade_zoom_relative_value = initial_zoom * upgrade_zoom_value
@onready var upgrade_zoom_vector = upgrade_zoom_relative_value * Vector2.ONE

func _ready():
	Events.closing_ship_upgrades.connect(_on_closing_ship_upgrades)
	Events.opening_ship_upgrades.connect(_on_opening_ship_upgrades)

var do_upgrade_animation = false
var selected_ship = null

func _process(_delta):
	if not do_upgrade_animation:
		return

	var offset = selected_ship.global_position - (self.get_screen_center_position() - self.offset)

	# TODO is that okay in terms of performance? We're creating a new tween on each frame...
	# It seems fluid but I am quite surprised
	(create_tween()
		.tween_property(self, "offset", offset, upgrade_zoom_speed)
		.set_ease(Tween.EASE_IN_OUT))
	(create_tween()
		.tween_property(self, "zoom", upgrade_zoom_vector, upgrade_zoom_speed)
		.set_ease(Tween.EASE_IN_OUT))

func _on_opening_ship_upgrades(ship: Node2D):
	do_upgrade_animation = true
	selected_ship = ship

func _on_closing_ship_upgrades():
	do_upgrade_animation = false

	(self
		.create_tween()
		.tween_property(self, "offset", Vector2.ZERO, upgrade_zoom_speed)
		.set_ease(Tween.EASE_IN_OUT))
	(self
		.create_tween()
		.tween_property(self, "zoom", initial_zoom, upgrade_zoom_speed)
		.set_ease(Tween.EASE_IN_OUT))
