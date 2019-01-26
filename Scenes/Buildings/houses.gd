extends Node

func _ready():
	pass

func get_random_house() -> Node:
	return get_child(0).duplicate(DUPLICATE_USE_INSTANCING)

func get_residential_house() -> Node:
	return get_child(0).duplicate(DUPLICATE_USE_INSTANCING)

func get_skyscraper_house() -> Node:
	return get_child(1).duplicate(DUPLICATE_USE_INSTANCING)