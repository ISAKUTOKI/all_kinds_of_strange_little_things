extends Node


func wait_frames(count: int) -> void:
	for i in range(count):
		await get_tree().process_frame
