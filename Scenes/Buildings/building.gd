extends Spatial
class_name Building

func _ready():
	pass

func _get_collision_shape() -> Shape:
	var col_shape : CollisionShape = get_node(name + "/col2/shape") as CollisionShape
	
	if col_shape:
		return col_shape.shape
	
	return null

func _get_mesh() -> Mesh:
	var mesh : MeshInstance = get_node(name) as MeshInstance
	
	if mesh:
		return mesh.mesh
	
	return null