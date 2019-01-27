extends KinematicBody

const MAX_SPEED = 100.0

onready var Houses = preload("res://Scenes/Buildings/HouseFactory.tscn").instance()

var building : Spatial = null
var movement_speed : float = 10.0
var current_speed : float = 0.0 setget set_current_speed
var camera_sens : float = 3.0

func _ready() -> void:
	# set building and grab building data
	building = Houses.get_residential_house()
	
	for child in $Collision.get_children():
		child.connect("body_entered", child, "set_rigid_arg")
	
	#add_child(building)
	
	#if building:
	#	$Collision/Mesh.mesh = building.mesh
	#	
	#	for i in $Collision/Mesh.get_surface_material_count():
	#		$Collision/Mesh.set_surface_material(i, building.get_surface_material(i))
	#	
	#	if building.has_node("col/shape2"):
	#		$Collision.shape = building.get_node("col/shape2").shape
	#	else:
	#		print("ERR: convex collision shape not found!")
		#$Collision.shape = building._get_collision_shape()
	
	# Other stuff?

func _input(event : InputEvent) -> void:
	pass

func _physics_process(delta : float) -> void:
	movement(delta)
	
	for i in get_slide_count():
		var coldata = get_slide_collision(i)
		
		if coldata.collider is Interactable:
			coldata.collider.set_rigid()
		
		current_speed *= 0.3
	
	update_camera(delta)

func movement(delta : float) -> void:
	# Move in house direction with current momentum (approach axis' length value * max momentum).
	# Dot product house direction and stick direction, to see if movement should be forward or reverse
	# If reverse rotation and movement should be backward (?). If not, regular
	
	# LS Input only effects momentum amount and rotating towards direction.
	
	var horizontal = Input.get_action_strength("ls_left") - Input.get_action_strength("ls_right")
	var vertical = Input.get_action_strength("ls_up") - Input.get_action_strength("ls_down")
	
	var movement : Vector2 = Vector2(horizontal, vertical).rotated(-$Camera_Rot.rotation.y)
	var movement3 : Vector3 = Vector3(movement.x, 0.0, movement.y)
	
	var extreme : float = movement.length_squared()
	if (movement3.dot($Collision.transform.basis.z) < 0):
		extreme *= -1
	
	if current_speed < extreme:
		current_speed = min(current_speed + 0.6 * delta, 1)
	else:
		current_speed = max(current_speed - 0.3 * delta, -1)
	
	if not movement == Vector2():
		var t
		if (movement3.dot($Collision.transform.basis.z) >= 0):
			t = $Collision.transform.looking_at(-movement3 + $Collision.transform.origin, Vector3.UP)
		else:
			t = $Collision.transform.looking_at(movement3 + $Collision.transform.origin, Vector3.UP)
		
		var old_quat = Quat($Collision.transform.basis)
		var new_quat = Quat(t.basis)
		
		var newer_quat = old_quat.slerp(new_quat, 1 - pow(0.5, delta))
		
		$Collision.transform.interpolate_with(t, 1)
		
		$Collision.transform.basis = Basis(newer_quat)
	
	var coldata = move_and_slide($Collision.transform.basis.z * current_speed * MAX_SPEED, Vector3.UP, true)
	
	translation.y = 0

func update_camera(delta : float) -> void:
	var horizontal = Input.get_action_strength("rs_left") - Input.get_action_strength("rs_right")
	
	$Camera_Rot.rotate_y(horizontal * delta * camera_sens)
	
	if $Camera_Rot/Camera_Cast.is_colliding():
		$Camera_Rot/Cam.transform.origin = $Camera_Rot/Camera_Cast.to_local($Camera_Rot/Camera_Cast.get_collision_point()) * 0.9
	else:
		$Camera_Rot/Cam.transform.origin = Vector3(0, 11, -14) * 0.9

func set_current_speed(new_speed : float) -> void:
	current_speed = clamp(new_speed, -1.0, 1.0)