extends HBoxContainer

enum PlayerOrMothership {
	PLAYER,
	MOTHERSHIP
}
@export var player_or_mothership = PlayerOrMothership.PLAYER

@onready var health_bar = $Health
@onready var ship_icon = $ShipIcon

const icon_mapping = {
	PlayerOrMothership.PLAYER: preload("res://hud/vaisseau_joueur_ui.png"),
	PlayerOrMothership.MOTHERSHIP: preload("res://hud/mothership_ui.png"),
}

const event_mapping = {
	PlayerOrMothership.PLAYER: "player_hp_changed",
	PlayerOrMothership.MOTHERSHIP: "mothership_hp_changed",
}

func _ready():
	Events.connect(event_mapping[player_or_mothership], _on_hp_changed)
	ship_icon.texture = icon_mapping[player_or_mothership]
		
	
func _on_hp_changed(health, max_health):
	health_bar.max_value = max_health
	health_bar.value = health
