extends Spatial

onready var Houses = preload("res://Scenes/Buildings/HouseFactory.tscn").instance()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var envLawn = load("res://Scenes/Environment/lawn.tscn")
var envPaved = load("res://Scenes/Environment/paved.tscn")
var envRoadH = load("res://Scenes/Environment/roadH.tscn")
var envRoadV = load("res://Scenes/Environment/roadV.tscn")
var envIntersection = load("res://Scenes/Environment/intersection.tscn")
var scenes
var houses

# Called when the node enters the scene tree for the first time.
func _ready():
	buildMap()
	populateHouses()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func buildMap():
	scenes = []
	for r in range(Procedural.ROWS):
		scenes.append([])
		for c in range(Procedural.COLS):
			match Procedural.world_grid[r][c]:
				"|": 
					scenes[r].append(envRoadV.instance())
				"-":
					scenes[r].append(envRoadH.instance())
				"+":
					scenes[r].append(envIntersection.instance())
				_:
					if (int(Procedural.world_grid[r][c]) > 7):
						scenes[r].append(envPaved.instance())
					else:
						scenes[r].append(envLawn.instance())
			scenes[r][c].translation.x = (20*r)
			scenes[r][c].translation.z = (-20*c)
			add_child(scenes[r][c])
			
func populateHouses():
	houses = []
	for r in range(Procedural.ROWS):
		houses.append([])
		for c in range(Procedural.COLS):
			var building
			if (Procedural.control[r][c] != " " and 
			    Procedural.control[r][c] != "X"):
				match Procedural.world_grid[r][c]:
					"0":
						houses[r].append(Houses.get_residential_house())
					"1":
						houses[r].append(Houses.get_residential_house())
					"2":
						houses[r].append(Houses.get_residential_house())
					"3":
						houses[r].append(Houses.get_residential_house())
					"4":
						houses[r].append(Houses.get_residential_house())
					"5":
						houses[r].append(Houses.get_residential_house())
					"6":
						houses[r].append(Houses.get_residential_house())
					"7":
						houses[r].append(Houses.get_residential_house())
					"8":
						houses[r].append(Houses.get_skyscraper_house())
					"9":
						houses[r].append(Houses.get_skyscraper_house())
					_:
						houses[r].append(null)
			else:
				houses[r].append(null)
				
			if (houses[r][c]):
				add_child(houses[r][c])
				
				houses[r][c].translation.x = (20*r )
				houses[r][c].translation.z = (-20*c )
			match Procedural.control[r][c]:
				"^":
					houses[r][c].rotation.y = deg2rad(90);
				"v":
					houses[r][c].rotation.y = deg2rad(270);
				"<":
					houses[r][c].rotation.y = deg2rad(180);
				">":
					houses[r][c].rotation.y = deg2rad(0);
			