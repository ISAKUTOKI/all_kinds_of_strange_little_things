extends Camera2D

@export var follow_target:bool=false
@export var target: Label


func _process(_delta: float) -> void:
	if not follow_target:
		return
	if target == null:
		return
	position = target.position
