extends Control

@onready var civilians_left_label = %AmountCiviliansLeft

func set_civilians_left(nb_civilians_left):
	civilians_left_label.update_text(nb_civilians_left)
