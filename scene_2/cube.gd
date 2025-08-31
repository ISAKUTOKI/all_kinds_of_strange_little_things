extends Node3D
class_name Cube

@onready var cube: Node3D = $"."

var original_cubies: Array[MeshInstance3D] = []
var original_cubies_pos: Array[Vector3] = []
var original_cubies_rot: Array[Vector3] = []
var original_cubies_name: Array[String] = []

var target_cubies: Array[MeshInstance3D] = []
var target_cubies_name: Array[String] = []

var rotation_records := []
var step: int = 0

enum RotateIndex { x0, x1, x2, y0, y1, y2, z0, z1, z2 }


func _ready() -> void:
	_get_all_cubies()
	Scene2GlobalSignalBus.rotate_cubies.connect(_on_rotate_cubies)
	Scene2GlobalSignalBus.initialize_cube.connect(_on_initialize_cube)
	Scene2GlobalSignalBus.restore_cube.connect(_on_restore_cube)


func _on_rotate_cubies(index: Cube.RotateIndex, direction: int):
	_rotate_target_cubies(index, direction)


func _on_initialize_cube():
	_reset_cube()


func _on_restore_cube():
	_restore_cube()


func _get_target_cubies(index: RotateIndex):
	match index:
		# x轴
		RotateIndex.x0:
			for i in original_cubies:
				if i.position.x > 0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		RotateIndex.x1:
			for i in original_cubies:
				if i.position.x > -0.3 and i.position.x < 0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		RotateIndex.x2:
			for i in original_cubies:
				if i.position.x < -0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		# y轴
		RotateIndex.y0:
			for i in original_cubies:
				if i.position.y > 0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		RotateIndex.y1:
			for i in original_cubies:
				if i.position.y > -0.3 and i.position.y < 0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		RotateIndex.y2:
			for i in original_cubies:
				if i.position.y < -0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		# z轴
		RotateIndex.z0:
			for i in original_cubies:
				if i.position.z > 0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		RotateIndex.z1:
			for i in original_cubies:
				if i.position.z > -0.3 and i.position.z < 0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)
		RotateIndex.z2:
			for i in original_cubies:
				if i.position.z < -0.3:
					target_cubies.push_back(i)
					target_cubies_name.push_back(i.name)


func _rotate_target_cubies(index: Cube.RotateIndex, direction: int, is_recording: bool = true):
	target_cubies.clear()
	target_cubies_name.clear()
	_get_target_cubies(index)
	#print("index: ", index)
	#print("direction: ", direction)
	#print("target_cubies: ", target_cubies_name)
	#print("number: ", target_cubies.size())
	#print("________________________________________")
	# 质心
	var rotator := Node3D.new()
	add_child(rotator)
	for i in target_cubies:
		rotator.global_position += i.global_position
	rotator.global_position /= target_cubies.size()
	for cubie in target_cubies:
		cubie.reparent(rotator)
	# 轴向
	var axis := Vector3.ZERO
	match index:
		RotateIndex.x0, RotateIndex.x1, RotateIndex.x2:
			axis = Vector3(1, 0, 0)
		RotateIndex.y0, RotateIndex.y1, RotateIndex.y2:
			axis = Vector3(0, 1, 0)
		RotateIndex.z0, RotateIndex.z1, RotateIndex.z2:
			axis = Vector3(0, 0, 1)
	# 旋转
	#var tween = create_tween()
	rotator.rotate(axis, deg_to_rad(90 * direction))
	# 重置父级
	for cubie in target_cubies:
		cubie.reparent(cube)
	rotator.queue_free()
	# 记录步数
	if is_recording:
		step += 1
		_record_rotate(index, direction)


func _record_rotate(index, direction):
	var record = {}
	record["step"] = step
	record["index"] = index
	record["direction"] = direction
	rotation_records.push_front(record)


func _reset_cube():
	step = 0
	var _index = 0
	for i in original_cubies:
		i.rotation = original_cubies_rot[_index]
		i.position = original_cubies_pos[_index]
		_index += 1


func _restore_cube(is_specified_step: bool = false, restore_step: int = 0):
	if is_specified_step:
		if restore_step == 0:
			printerr("————指定步数类型退回但是没有给定步数————")
			return
	else:
		restore_step = step
	while restore_step > 0:
		var current_step = rotation_records.pop_front()
		var index = current_step["index"]
		var dir = current_step["direction"] * -1
		_rotate_target_cubies(index, dir, false)
		restore_step -= 1
		step -= 1
		await get_tree().create_timer(0.15).timeout


func _get_all_cubies():
	for cubie in cube.get_children(false):
		if cubie is MeshInstance3D:
			original_cubies.push_back(cubie)
			original_cubies_pos.push_back(cubie.position)
			original_cubies_rot.push_back(cubie.rotation)
			original_cubies_name.push_back(cubie.name)

#TODO 判断旋转方向的逻辑
#TODO 旋转魔方的逻辑
