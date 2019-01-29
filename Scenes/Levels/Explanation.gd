extends Spatial

#onready var dir_controls

func _process(delta):
	#if (Settings.tank_controls):
	#	get_node("CanvasLayer/Control/TextureRect2").visible = false;
	#	get_node("CanvasLayer/Control/TextureRect3").visible = true;
	#else:
	#	get_node("CanvasLayer/Control/TextureRect2").visible = true;
	#	get_node("CanvasLayer/Control/TextureRect3").visible = false;
	
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Scenes/Levels/Game.tscn")
