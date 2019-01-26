extends KinematicBody

const MAX_SPEED = 10.0

var building : Building = null
var movement_speed : float = 10.0
var current_speed : float = 0.0 setget set_current_speed
var camera_sens : float = 3.0

func _ready() -> void:
	# set building and grab building data
	var building_scene = load("res://Scenes/Buildings/building.tscn")
	#ResourceLoader.load("res://Scenes/Buildings/building.tscn").
	building = building_scene.instance()
	
	if building:
		$Mesh.mesh = building._get_mesh()
		
		$Collision.shape = building._get_collision_shape()
	
	# Other stuff?

func _input(event : InputEvent) -> void:
	pass

func _physics_process(delta : float) -> void:
	movement(delta)
	update_camera(delta)

func movement(delta : float) -> void:
	# Move in house direction with current momentum (approach axis' length value * max momentum).
	# Dot product house direction and stick direction, to see if movement should be forward or reverse
	# If reverse rotation and movement should be backward (?). If not, regular
	
	# LS Input only effects momentum amount and rotating towards direction.
	
	var horizontal = Input.get_action_strength("ls_left") - Input.get_action_strength("ls_right")
	var vertical = Input.get_action_strength("ls_up") - Input.get_action_strength("ls_down")
	
	var movement : Vector2 = Vector2(horizontal, vertical).rotated(-$Camera_Rot.rotation.y)
	
	if movement != Vector2():
		var movement3 : Vector3 = Vector3(movement.x, 0.0, movement.y)
		
		move_and_slide(movement3 * movement_speed, Vector3.UP, true)

func update_camera(delta : float) -> void:
	var horizontal = Input.get_action_strength("rs_left") - Input.get_action_strength("rs_right")
	
	$Camera_Rot.rotate_y(horizontal * delta * camera_sens)
	
	if $Camera_Rot/Camera_Cast.is_colliding():
		$Camera_Rot/Cam.transform.origin = $Camera_Rot/Camera_Cast.to_local($Camera_Rot/Camera_Cast.get_collision_point()) * 0.9
	else:
		$Camera_Rot/Cam.transform.origin = Vector3(0, 11, -14) * 0.9

func set_current_speed(new_speed : float) -> void:
	current_speed = clamp(new_speed, 0.0, MAX_SPEED)