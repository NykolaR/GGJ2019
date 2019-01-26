extends Node

# do we need self anywhere?
var rows = 20
var cols = 20
var numberZones = 10
var minRowStreets = 4
var maxRowStreets = 6
var minColStreets = 3
var maxColStreets = 5
var replaceChance = 3 # / 10

var world_grid
var control
var scenes

func _ready():
	world_grid = []
	control = []
	for r in range(rows):
		world_grid.append ([])
		control.append([])
		for c in range(cols):
			world_grid[r].append("L")
			control[r].append(" ")
	addVerticalCols()
	addHorizontalRows()
	#combineAdjacent()
	pickStartingPlace()
	addZones()
	findHouseDirections()
	printWorldNice()
	printControlNice()
	pass

func addVerticalCols():
	var colStreetsDiff = maxColStreets - minColStreets
	var c = 0
	var offset = randi() % colStreetsDiff
	print (offset)
	c += offset
	while c < cols:	
		for r in range(rows):
			world_grid[r][c] = "|"
		offset = randi() % colStreetsDiff + minColStreets
		print (offset)
		c += offset

#always call me after addVerticalRows. :)
func addHorizontalRows():
	var rowStreetsDiff = maxRowStreets - minRowStreets
	var r = 0
	var offset = randi()%rowStreetsDiff
	r += offset
	while r < rows:	
		for c in range(cols):
			if (world_grid[r][c]=="|"):
				world_grid[r][c] = "+"
			else:
				world_grid[r][c] = "-"
		offset = randi() % rowStreetsDiff + minRowStreets
		r += offset
	
# this is where care is needed to ensure there is always a path to the goal.
func combineAdjacent():
	# this function is shyte. Don't use it. 
	for r in range(rows):
		for c in range(cols):
			if ((world_grid[r][c]=="|" or 
			    world_grid[r][c]=="-" or 
			    world_grid[r][c]=="+") and
			    randi()%10 < replaceChance):
					world_grid[r][c] = "L"
	
func addZones():
	for r in range (rows):
		for c in range (cols):
			if (world_grid[r][c] == "L"):
				var region = randi()%numberZones
				var stackRC = []
				world_grid[r][c] = String(region)
				stackRC.append([r+1,c])
				stackRC.append([r,c+1])
				while stackRC.size()>0:
					var tuple = stackRC[0]
					stackRC.remove(0)
					if (tuple[0] < rows and
					    tuple[1] < cols and
					    world_grid[tuple[0]][tuple[1]] == "L"):
						world_grid[tuple[0]][tuple[1]] = String(region)
						stackRC.append([tuple[0]+1,tuple[1]])
						stackRC.append([tuple[0],tuple[1]+1])

func flipCoin():
	if (randi()%2==0):
		return true
	else:
		return false

func findHouseDirections():
	for r in range (rows):
		for c in range (cols):
			var roadUp = r-1 >= 0      and world_grid[r-1][c] == "-"
			var roadDown = r+1 < rows  and world_grid[r+1][c] == "-"
			var roadLeft = c-1 >= 0    and world_grid[r][c-1] == "|"
			var roadRight = c+1 < cols and world_grid[r][c+1] == "|"
			if   roadUp   and roadLeft:
				if (flipCoin()):
					control[r][c] = "^"
				else:
					control[r][c] = "<"
			elif roadDown and roadLeft:
				if (flipCoin()):
					control[r][c] = "v"
				else:
					control[r][c] = "<"
			elif roadUp   and roadRight:
				if (flipCoin()):
					control[r][c] = "^"
				else:
					control[r][c] = ">"
			elif roadDown and roadRight:
				if (flipCoin()):
					control[r][c] = "v"
				else:
					control[r][c] = ">"
			elif roadUp:
				control[r][c] = "^"
			elif roadDown:
				control[r][c] = "v"
			elif roadRight:
				control[r][c] = ">"
			elif roadLeft:
				control[r][c] = "<"
	            
func pickStartingPlace():
	var locations = []
	for r in range (rows):
		for c in range (cols):
			if (world_grid[r][c] == "|" or
			    world_grid[r][c] == "-" or
			    world_grid[r][c] == "+"):
				locations.append([r,c])
	var starting = locations[randi()%(locations.size())]
	control[starting[0]][starting[1]] = "O"
	
func pickDestinationLot():
	pass
				
func printWorldNice():
	var outString = ""
	for r in range(rows):
		for c in range(cols):
			outString += world_grid[r][c] + " "
		outString += "\n"
	print (outString)
	
func printControlNice():
	var outString = ""
	for r in range(rows):
		for c in range(cols):
			outString += control[r][c] + " "
		outString += "\n"
	print (outString)
	
# run me after running everything else. :)
func buildMap():
	var envLawn = load("res://Scenes/Environment/lawn.tscn")
	var envRoadH = load("res://Scenes/Environment/roadH.tscn")
	var envRoadV = load("res://Scenes/Environment/roadV.tscn")
	var envIntersection = load("res://Scenes/Environment/intersection.tscn")
	scenes = []
	for r in range(rows):
		scenes.append([])
		for c in range(cols):
			match world_grid[r][c]:
				"|": 
					scenes.append[envRoadV.instance()]
					add_child(scenes[r][c])
				"-":
					scenes.append[envRoadH.instance()]
					add_child(scenes[r][c])
				"+":
					scenes.append[envIntersection.instance()]
					add_child(scenes[r][c])
				_:
					scenes.append[envLawn.instance()]
					add_child(scenes[r][c])