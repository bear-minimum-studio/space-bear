extends Control

func _ready():
	FlockResources.resources_change.connect(_update_resources_count)
	_update_resources_count()

func _update_resources_count():
	$Label.text = "%s resources left" % FlockResources.resources
