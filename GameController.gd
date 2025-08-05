extends Node

func wait_frames(count: int):
	for i in count:
		await get_tree().process_frame


func wait_times(seconds: float):
	await get_tree().create_timer(seconds).timeout
