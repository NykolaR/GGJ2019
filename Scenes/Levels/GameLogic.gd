extends Node

const STARTING_LOT_VALUE = 500000
const STARTING_HOUSE_VALUE = 500000
const BASE_DECAY = 50
const SLOPE_DECAY = 50 #this will be scaled by closeness to goal
var lotValue 
var lotDecay
var houseValue
var propertyDamage
var genLevelScene = load("res://Scenes/Levels/GenLevel.tscn")
var playerScn = load("res://Scenes/Player/Player.tscn")
var envLandingZone = load("res://Scenes/Environment/LandingZone.tscn")
var genLevel
var player
var landingZone
var penaltyScale
var totalValue
var lockedIn
var gameOver = false

func DeductScore ():
	houseValue -= 7000
	if houseValue < 0:
		houseValue = 0
		gameOver()

func gameOver():
	if not gameOver:
		gameOver = true
		lockedIn = true
		var text = "Game Over - Your House is Worthless. \nPress (X) to start a new level"
		var label = get_node("CanvasLayer/Control/TextureRect2/Label")
		get_node("CanvasLayer/Control/Blue").visible = false
		get_node("CanvasLayer/Control/Red").visible = true
		label.text = text

func _ready():
	lockedIn = false
	spawnPlayer()
	addLandingZone()
	genLevel = genLevelScene.instance()
	add_child(genLevel)
	
	lotValue = STARTING_LOT_VALUE
	houseValue = STARTING_HOUSE_VALUE
	var distance = abs(int(Procedural.startingLocation[0]) \
	             - int(Procedural.goalLocation[0])) + \
			       abs (int(Procedural.startingLocation[1]) \
   	             - int(Procedural.goalLocation[1]))
	#print (distance)
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
	
	if not lockedIn:
		lotValue -= lotDecay * delta * 100
		if lotValue < 0:
			lotValue = 0
		checkMyScore()
		updateGui()
		if (Input.is_action_just_pressed("ui_accept")):
				lockIn()
	else: 
		if (Input.is_action_just_pressed("ui_accept")):
			nextLevel()
	
func nextLevel():
	Procedural.newLevel()
	get_tree().change_scene("res://Scenes/Levels/Game.tscn")
	
func checkMyScore():
	var playerLocation = Vector2(player.translation.x, player.translation.z)
	var destinationLocation = Vector2(Procedural.goalLocation[0]*20, Procedural.goalLocation[1]*-20)
	var distance = (playerLocation - destinationLocation).length()
	# print (distance) # Thi   s is like 300-500 if far away
	# goal is player should keep this under 1. -10% / point.
	if (distance >= 5):
		penaltyScale = 1.0
	else:
		#distance is range 0 - 5
		penaltyScale = distance / 10.0
	var cosineAngle = player.get_node("Collision").transform.basis.z.dot(landingZone.transform.basis.z)
	if cosineAngle < 0:
		penaltyScale = 1.0
	else:
		penaltyScale += 0.5 * (1.0 - cosineAngle)
	if (penaltyScale > 1.0):
		penaltyScale = 1.0
	totalValue = (1.0-penaltyScale)*(houseValue+lotValue)
	
func updateGui():
	var text = "Current Value of House....." + str(houseValue).pad_decimals(2) + "\n Current Value of Lot...." + str(lotValue).pad_decimals(2) + " \n Current Distance from Lot Penalty...." + str(penaltyScale*100).pad_decimals(0) + "%\n 	Total Cash in Value..." + str(totalValue).pad_decimals(2)
	var label = get_node("CanvasLayer/Control/TextureRect2/Label")
	label.text = text
	
func spawnPlayer ():
	player = playerScn.instance()
	player.translation.x = Procedural.startingLocation[0] * 20
	player.translation.z = Procedural.startingLocation[1] * -20
	add_child(player)
	
func addLandingZone():
	landingZone = envLandingZone.instance()
	add_child(landingZone)
	landingZone.translation.x = Procedural.goalLocation[0] * 20
	landingZone.translation.z = Procedural.goalLocation[1] * -20
	landingZone.rotation.y = Procedural.destinationRotation
	
func lockIn():
	lockedIn = true
	var text = "Final Value....." + str(totalValue).pad_decimals(2) + "\n \n Press (X) to start a new level"
	var label = get_node("CanvasLayer/Control/TextureRect2/Label")
	get_node("CanvasLayer/Control/Blue").visible = false
	get_node("CanvasLayer/Control/Green").visible = true
		
	label.text = text