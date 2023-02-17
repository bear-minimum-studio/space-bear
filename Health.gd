extends TextureProgressBar

func _ready():
	Events.connect("player_hp_changed", _on_hp_changed)
	
func _on_hp_changed(health, max_health):
	self.max_value = max_health
	self.value = health
