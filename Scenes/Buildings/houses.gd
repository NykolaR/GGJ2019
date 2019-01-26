extends Node

export (Array, PackedScene) var Houses = []

func _ready():
	pass

func get_random_house() -> Node:
	return null

func get_residential_house() -> Node:
	return Houses[0].instance()

func get_skyscraper_house() -> Node:
	return Houses[1].instance()