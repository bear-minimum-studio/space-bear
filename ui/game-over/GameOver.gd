extends Control

class_name GameOver

enum Reasons {
	MOTHERSHIP_DIED,
	PLAYER_DIED,
}
@onready var reason = $Panel/CenterContainer/VBoxContainer/Reason

func _input(event):
	if not self.visible:
		return

	if event.is_action_pressed('restart'):
		Events.restart.emit()

func set_reason(defeat_reason: Reasons):
	if defeat_reason == Reasons.MOTHERSHIP_DIED:
		reason.text = "Your mothership got destroyed."
		return
	
	reason.text = "Your ship got destroyed."
