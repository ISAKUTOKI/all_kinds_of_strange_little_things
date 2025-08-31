extends Node


func rotate_cubies(index: Cube.RotateIndex, direction: int):
	Scene2GlobalSignalBus.rotate_cubies.emit(index, direction)


func initialize_cube():
	Scene2GlobalSignalBus.initialize_cube.emit()


func restore_cube():
	Scene2GlobalSignalBus.restore_cube.emit()
