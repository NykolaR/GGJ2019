extends RigidBody

class_name Interactable
export var dead = true

func _ready():
	pass

func set_rigid() -> void:
	#get_tree().call_group("ScoreKeeper", "DeductScore")
	mode = MODE_RIGID
	
	apply_impulse(Vector3(), Vector3(randf(), randf(), randf()))

func set_rigid_arg(arg) -> void:
	if dead:
		return
	
	get_tree().call_group("ScoreKeeper", "DeductScore")
	
	mode = MODE_RIGID
	var global_t = global_transform
	
	var parent = get_node("../../../")
	
	if not parent.current_speed == null:
		parent.current_speed *= 0.2
	
	get_parent().remove_child(self)
	parent.get_node("Node").add_child(self)
	
	transform = global_t
	
	#collision_mask = 15
	
	if not translation == Vector3():
		collision_mask = 7
		dead = true
		arg.collision_layer = 0
	
	if arg.has_method("set_rigid"):
		arg.set_rigid()