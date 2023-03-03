extends Control

@onready var resources_count = $ResourcesCount


func _ready():
	FlockResources.resources_change.connect(_update_resources_count)
	_update_resources_count()

func _update_resources_count():
	resources_count.amount = FlockResources.resources
