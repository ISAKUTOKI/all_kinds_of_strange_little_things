extends Camera3D

@onready var ray: RayCast3D = $RayCast3D

var target: MeshInstance3D = null
var last_target: MeshInstance3D = null
var original_material = preload("res://scene_2/cube_material.tres")
var outline_material = preload("res://scene_2/cube_outline_material.tres")

var last_mouse_pos: Vector2


func _process(_delta: float) -> void:
	_outline()


func _input(event: InputEvent) -> void:
	# 判断目标
	if event is InputEventMouseMotion:
		var mouse_pos = event.position
		# 射线
		var from = self.project_ray_origin(mouse_pos)
		var dir = self.project_ray_normal(mouse_pos)
		var to = from + dir * 1000
		# 检测
		ray.target_position = ray.to_local(to)
		if ray.is_colliding():
			var collider = ray.get_collider()
			target = collider.get_parent() as MeshInstance3D
		else:
			target = null

	# 旋转cube
	if event is InputEventMouseButton:
		if event.is_action_pressed("rotate_cube"):
			_rotate_cube()
	# 旋转cubie
	if event is InputEventMouseButton and target:
		if event.is_action_pressed("rotate_cubie"):
			_rotate_cubie()


func _outline():
	if last_target != target:
		if last_target:
			last_target.material_override = original_material
		last_target = target
		if target:
			target.material_override = outline_material


func _rotate_cube():
	var dir = _get_mouse_direction()


func _rotate_cubie():
	var dir = _get_mouse_direction()
	var normal = _get_cubie_normal()
	var index = _get_rotate_index(dir)


func _get_mouse_direction() -> Vector2:
	var dir: Vector2
	return dir


func _get_cubie_normal():
	pass


func _get_rotate_index(direction: Vector2) -> Cube.RotateIndex:
	var ind: Cube.RotateIndex
	return ind
