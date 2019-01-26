extends Node

const STARTING_LOT_VALUE = 500000
const STARTING_HOUSE_VALUE = 500000
const BASE_DECAY = 50
const SLOPE_DECAY = 50 #this will be scaled by closeness to goal
var lotValue 
var lotDecay
var houseValue
var propertyDamage


func _ready():
	lotValue = STARTING_LOT_VALUE
	var distance = abs(int(Procedural.startingLocation[0]) \
	             - int(Procedural.goalLocation[0])) + \
			       abs (int(Procedural.startingLocation[1]) \
   	             - int(Procedural.goalLocation[1]))
	print (distance)
	var maxDistance = Procedural.ROWS + Procedural.COLS
	# farness will approach 1 if very very far, 0 if very near
	# the higher the value of farness, the slower that the
	# lot value should depreciate
	var farness = float(distance) / float(maxDistance)
	var closeness = 1 - farness
	lotDecay = BASE_DECAY + SLOPE_DECAY * closeness
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lotValue -= lotDecay * delta
	pass
