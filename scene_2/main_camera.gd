extends Camera3D

@onready var ray: RayCast3D = $RayCast3D

var target: MeshInstance3D = null
var last_target: MeshInstance3D = null
var original_material = preload("res://scene_2/cube_material.tres")
var outline_material = preload("res://scene_2/cube_outline_material.tres")


func _process(_delta: float) -> void:
	_outline()
	


func _input(event: InputEvent) -> void:
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

	if event is InputEventMouseButton and target:
		pass

func _outline():
	if last_target != target:
		if last_target:
			last_target.material_override = original_material
		last_target = target
		if target:
			target.material_override = outline_material
