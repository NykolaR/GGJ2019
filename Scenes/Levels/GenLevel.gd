extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var envLawn = load("res://Scenes/Environment/lawn.tscn")
var envRoadH = load("res://Scenes/Environment/roadH.tscn")
var envRoadV = load("res://Scenes/Environment/roadV.tscn")
var envIntersection = load("res://Scenes/Environment/intersection.tscn")
var scenes

# Called when the node enters the scene tree for the first time.
func _ready():
	buildMap()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func buildMap():
	scenes = []
	for r in range(Procedural.rows):
		scenes.append([])
		for c in range(Procedural.cols):
			match Procedural.world_grid[r][c]:
				"|": 
					scenes[r].append(envRoadV.instance())
				"-":
					scenes[r].append(envRoadH.instance())
				"+":
					scenes[r].append(envIntersection.instance())
				_:
					scenes[r].append(envLawn.instance())
			scenes[r][c].translation.x = (25*r)
			scenes[r][c].translation.z = (25*c)
			add_child(scenes[r][c])