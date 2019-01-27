extends RigidBody

class_name Interactable
export var dead = true

func _ready():
	pass

func set_rigid() -> void:
	mode = MODE_RIGID

func set_rigid_arg(arg) -> void:
	if dead:
		return
	
	mode = MODE_RIGID
	var global_t = global_transform.origin
	
	var parent = get_node("../../")
	get_parent().remove_child(self)
	parent.get_node("Node").add_child(self)
	
	translation = global_t
	
	#collision_mask = 15
	collision_mask = 7
	dead = true
	
	arg.set_rigid()