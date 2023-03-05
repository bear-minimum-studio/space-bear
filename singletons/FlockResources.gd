extends Node

const initial_resources = 100
var resources = initial_resources

signal resources_change

func spend_resource(amount: int):
	resources -= amount
	resources_change.emit()

func get_resources():
	return resources

func earn_resources(amount: int):
	resources += amount
	resources_change.emit()

func reset():
	resources = initial_resources
