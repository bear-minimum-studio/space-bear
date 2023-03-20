extends HBoxContainer

enum PlayerOrMothership {
	PLAYER,
	MOTHERSHIP
}
@export var player_or_mothership = PlayerOrMothership.PLAYER

@onready var health_bar = $Superpose/Health
@onready var ship_icon = $ShipIcon
@onready var shield_health_bar = $Superpose/ShieldHealth
@onready var hurt_animation = $ShipIcon/HurtAnimation

const icon_mapping = {
	PlayerOrMothership.PLAYER: preload("res://hud/vaisseau_joueur_ui.png"),
	PlayerOrMothership.MOTHERSHIP: preload("res://hud/mothership_ui.png"),
}

const event_hp_mapping = {
	PlayerOrMothership.PLAYER: "player_hp_changed",
	PlayerOrMothership.MOTHERSHIP: "mothership_hp_changed",
}

const event_shield_hp_mapping = {
	PlayerOrMothership.PLAYER: "player_shield_hp_changed",
	PlayerOrMothership.MOTHERSHIP: "mothership_shield_hp_changed",
}

func _ready():
	Events.connect(event_hp_mapping[player_or_mothership], _on_hp_changed)
	Events.connect(event_shield_hp_mapping[player_or_mothership], _on_shield_hp_changed)
	ship_icon.texture = icon_mapping[player_or_mothership]


func _on_hp_changed(health, max_health, difference):
	health_bar.max_value = max_health
	health_bar.value = health
	
	if difference == 0:
		return
	elif difference > 0:
		hurt_animation.animate_heal(ship_icon)
	else:
		hurt_animation.animate_hurt(ship_icon)

func _on_shield_hp_changed(health, max_health, _difference):
	shield_health_bar.max_value = max_health
	shield_health_bar.value = health
