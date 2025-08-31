extends Node3D
@onready var label: Label = $Label
@onready var cube: Node3D = $"../Cube"


func test():
	var index = randi_range(0, Cube.RotateIndex.size() - 1)
	var dir = [-1, 1].pick_random()
	CubeController.rotate_cubies(index, dir)


func _on_button_pressed() -> void:
	test()


func _on_button_2_pressed() -> void:
	CubeController.initialize_cube()


func _on_button_3_pressed() -> void:
	CubeController.restore_cube()


func _process(_delta: float) -> void:
	label.text = ""
	label.text += "步数： "
	label.text += str(cube.step)
