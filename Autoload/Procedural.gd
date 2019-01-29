extends Node

# do we need self anywhere?
const ROWS = 9
const COLS = 9
const NUMBER_ZONES = 10
const MIN_ROW_STREETS = 4
const MAX_ROW_STREETS = 6
const MIN_COL_STREETS = 3
const MAX_COL_STREETS = 5
const replaceChance = 3 # / 10
const TILE_WIDTH = 20

var world_grid
var control
var scenes
var goalLocation
var goalDirection
var startingLocation
var destinationRotation

func _ready():
	randomize()
	randomize()
	randomize()
	world_grid = []
	control = []
	for r in range(ROWS):
		world_grid.append ([])
		control.append([])
		for c in range(COLS):
			world_grid[r].append("L")
			control[r].append(" ")
	addVerticalCols()
	addHorizontalRows()
	#combineAdjacent()
	addZones()
	findHouseDirections()
	pickStartingPlace()
	pickDestinationLot()
	printWorldNice()
	printControlNice()

func newLevel():
	world_grid = []
	control = []
	for r in range(ROWS):
		world_grid.append ([])
		control.append([])
		for c in range(COLS):
			world_grid[r].append("L")
			control[r].append(" ")
	addVerticalCols()
	addHorizontalRows()
	#combineAdjacent()
	addZones()
	findHouseDirections()
	pickStartingPlace()
	pickDestinationLot()
	printWorldNice()
	printControlNice()

func addVerticalCols():
	var colStreetsDiff = MAX_COL_STREETS - MIN_COL_STREETS
	var c = 0
	var offset = randi() % colStreetsDiff
	#print (offset)
	c += offset
	while c < COLS:	
		for r in range(ROWS):
			world_grid[r][c] = "|"
		offset = randi() % colStreetsDiff + MIN_COL_STREETS
		#print (offset)
		c += offset

#always call me after addVerticalRows. :)
func addHorizontalRows():
	var rowStreetsDiff = MAX_ROW_STREETS - MIN_ROW_STREETS
	var r = 0
	var offset = randi()%rowStreetsDiff
	r += offset
	while r < ROWS:	
		for c in range(COLS):
			if (world_grid[r][c]=="|"):
				world_grid[r][c] = "+"
			else:
				world_grid[r][c] = "-"
		offset = randi() % rowStreetsDiff + MIN_ROW_STREETS
		r += offset
	
# this is where care is needed to ensure there is always a path to the goal.
func combineAdjacent():
	# this function is shyte. Don't use it. 
	for r in range(ROWS):
		for c in range(COLS):
			if ((world_grid[r][c]=="|" or 
			    world_grid[r][c]=="-" or 
			    world_grid[r][c]=="+") and
			    randi()%10 < replaceChance):
					world_grid[r][c] = "L"
	
func addZones():
	for r in range (ROWS):
		for c in range (COLS):
			if (world_grid[r][c] == "L"):
				var region = randi()%NUMBER_ZONES
				var stackRC = []
				world_grid[r][c] = String(region)
				stackRC.append([r+1,c])
				stackRC.append([r,c+1])
				while stackRC.size()>0:
					var tuple = stackRC[0]
					stackRC.remove(0)
					if (tuple[0] < ROWS and
					    tuple[1] < COLS and
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
	for r in range (ROWS):
		for c in range (COLS):
			var roadUp = r-1 >= 0      and world_grid[r-1][c] == "-"
			var roadDown = r+1 < ROWS  and world_grid[r+1][c] == "-"
			var roadLeft = c-1 >= 0    and world_grid[r][c-1] == "|"
			var roadRight = c+1 < COLS and world_grid[r][c+1] == "|"
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
	for r in range (ROWS):
		for c in range (COLS):
			if (world_grid[r][c] == "|" or
			    world_grid[r][c] == "-" or
			    world_grid[r][c] == "+"):
				locations.append([r,c])
	startingLocation = locations[randi()%(locations.size())]
	control[startingLocation[0]][startingLocation[1]] = "O"

func pickDestinationLot():
	var possibleLots = []
	for r in range (ROWS):
		for c in range (COLS):
			if (control[r][c] == ">" or
			    control[r][c] == "<" or
			    control[r][c] == "^" or
				control[r][c] == "v" and 
				int(world_grid[r][c]) < 8):
				possibleLots.append([r,c])
	goalLocation = possibleLots[randi()%(possibleLots.size())]
	goalDirection = control[goalLocation[0]][goalLocation[1]]
	print (goalDirection)
	control[goalLocation[0]][goalLocation[1]] = "X"
	match Procedural.goalDirection:
		"^":
			destinationRotation = deg2rad(270);
		"v":
			destinationRotation =  deg2rad(90);
		"<":
			destinationRotation =  deg2rad(0);
		">":
			destinationRotation =  deg2rad(180);

func printWorldNice():
	var outString = ""
	for r in range(ROWS):
		for c in range(COLS):
			outString += world_grid[r][c] + " "
		outString += "\n"
	print (outString)

func printControlNice():
	var outString = ""
	for r in range(ROWS):
		for c in range(COLS):
			outString += control[r][c] + " "
		outString += "\n"
	print (outString)