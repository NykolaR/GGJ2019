extends Spatial

onready var tank = $VBox/HBox/tank
onready var dir = $VBox/HBox/dir

func _process(delta):
	# is probably overkill/inefficient to check every frame
	# but also, probably doesn't really matter
	
	if Settings.tank_controls:
		tank.self_modulate = Settings.GREEN
		dir.self_modulate = Settings.RED
	else:
		dir.self_modulate = Settings.GREEN
		tank.self_modulate = Settings.RED
	
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Scenes/Levels/Game.tscn")
