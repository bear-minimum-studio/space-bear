extends Control
@onready var amount = $HBoxContainer/Amount

func update_text(nb_of_civilians : int):
	amount.text = "%s" % nb_of_civilians
