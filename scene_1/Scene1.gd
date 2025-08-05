extends Node2D

@onready var background: ColorRect = $Background
@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var camera: Camera2D = $Camera2D

@export_category("基础文本")
@export var initialize_text: String = ""

@export_category("颜色设置")
@export_color_no_alpha var background_original_color: Color = Color(59, 59, 59, 255) / 255.0
@export_color_no_alpha var background_target_color: Color = Color(10, 12, 22, 255) / 255.0
@export_color_no_alpha var text_terget_color: Color = Color(150, 187, 255, 255) / 255.0
var target_text: String
var original_text: String
var target_pos_center: Vector2i
var label_2_target_length: int
var label_1_target_text: String

@export_category("其他设置")
@export_range(0.1, 1.0, 0.05) var anime_time: float = 0.35
@export_range(1.1, 1.5, 0.05) var camera_zoom: float = 1.35


func _ready() -> void:
	if initialize_text == "":
		_initialize(label_1.text)
	else:
		_initialize(initialize_text)
	original_text = label_1.text


func _initialize(_text: String):
	label_1.text = _text
	background.z_index = -99
	# 获取
	target_pos_center = (get_viewport().size - Vector2i(label_1.size)) / 2
	label_2_target_length = _get_first_line_text_length(label_1.text)
	# 初始化
	_set_label_1()
	_set_label_2()
	camera.position = get_viewport().size / 2
	background.size = get_viewport().size


func _get_first_line_text_length(target_string: String) -> int:
	var length: int = 0
	for i in target_string.length():
		if target_string[i] == "\n":
			break
		length += 1
	return length


func _set_label_1():
	var count = label_2_target_length
	target_text = ""
	for i in label_1.text:
		if count == 0:
			break
		target_text += i
		count -= 1
	label_1.text = target_text
	#print("label_1.text: ", label_1.text)
	label_1.position = target_pos_center
	label_1.modulate = text_terget_color
	label_1.visible_ratio = 0


func _set_label_2():
	label_2.text = ""
	for i in label_2_target_length:
		label_2.text += "\\"
	#print("label_2.text: ", label_2.text)
	label_2.size = label_1.size
	label_2.position = label_1.position
	#label_2.modulate = text_terget_color


func _on_label_2_mouse_entered() -> void:
	_anime(true)
	#print("进入")


func _on_label_2_mouse_exited() -> void:
	_anime(false)
	#print("退出")


func _anime(_show: bool = true):
	# 各种变量
	var target_zoom: Vector2
	var interval_time: float = anime_time / (label_1.text.length() + 2)
	var tween_1 = create_tween()  # label_1(退出延迟)
	var tween_2 = create_tween()  # label_2(进入延迟)
	var tween_3 = create_tween().set_parallel()  # other
	var l1: int
	var l2: int
	# 根据条件进行判断
	if _show:
		l1 = 1
		l2 = 0
		target_zoom = Vector2(1, 1) * camera_zoom
		tween_2.tween_interval(interval_time)
		tween_3.tween_property(background, "color", background_target_color, anime_time)
	else:
		l1 = 0
		l2 = 1
		target_zoom = Vector2(1, 1)
		tween_1.tween_interval(interval_time)
		tween_3.tween_property(background, "color", background_original_color, anime_time)
	#print(label_1)
	# 动画运行
	tween_1.tween_property(label_1, "visible_ratio", l1, anime_time)
	tween_2.tween_property(label_2, "visible_ratio", l2, anime_time)
	tween_3.tween_property(camera, "zoom", target_zoom, anime_time)


func _is_english(_text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[\\x00-\\x7F]+$")  # ASCII 字符范围（英语及常规符号）
	return regex.search(_text) != null
