extends Control

func _input(event):
	if not self.visible:
		return

	if event.is_action_pressed('restart'):
		Events.restart.emit()
