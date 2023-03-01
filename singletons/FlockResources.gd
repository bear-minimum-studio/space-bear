extends Node

var resources = 100

signal resources_change

func spend_resource(amount: int):
	resources -= amount
	resources_change.emit()

func get_resources():
	return resources
