extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Settings.tank_controls):
		get_node("CanvasLayer/Control/TextureRect2").visible = false;
		get_node("CanvasLayer/Control/TextureRect3").visible = true;
	else:
		get_node("CanvasLayer/Control/TextureRect2").visible = true;
		get_node("CanvasLayer/Control/TextureRect3").visible = false;
		
	pass
