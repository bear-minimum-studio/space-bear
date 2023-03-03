extends Node2D

@onready var flock = $Flock

func _ready():
	WorldReference.current_world = self
	
	Events.convoy_reached_wormhole.connect(_on_convoy_reached_wormhole)
	Events.player_reached_wormhole.connect(_on_player_reached_wormhole)


func _on_convoy_reached_wormhole():
	print('level ended')

func _on_player_reached_wormhole():
	print('you reached the level end')

