extends Control

@onready var progress_element_container = %ProgressElementContainer
@onready var dot = %Dot
@onready var end = %End

func _set_progress(percentage: float):
	if end == null or dot == null:
		return

	var total_size = (end.get_global_rect().get_center() - dot.get_global_rect().get_center()).x
	progress_element_container.position.x = percentage * total_size

func _ready():
	Events.mothership_advance.connect(_on_mothership_advance)
	
func _on_mothership_advance(progress: float):
	_set_progress(progress)
