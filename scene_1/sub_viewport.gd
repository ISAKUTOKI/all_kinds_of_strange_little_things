extends SubViewportContainer

@onready var line_edit: LineEdit = $SubViewport/Button/LineEdit
@onready var root_node: Node2D = $".."


func _on_button_pressed() -> void:
	if line_edit.text == "":
		root_node._initialize(root_node.original_text)
	else:
		if root_node._is_english(line_edit.text):
			root_node._initialize(line_edit.text)
		else:
			_waring()
	line_edit.text = ""


@export_category("用户输入编辑栏设置")
@export var waring_timer: float = 2.0
var waring_placehoder_text: String = " - I SAID: ENGLISH ONLY ! ! ! - "


func _waring():
	line_edit.placeholder_text = ""
	for i in waring_placehoder_text:
		line_edit.placeholder_text += i
		await GameController.wait_times(0.03)
	await GameController.wait_times(2)
	line_edit.placeholder_text = " - ENGLISH ONLY - "
