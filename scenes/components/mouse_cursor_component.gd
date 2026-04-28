extends Node

func _ready() -> void:
	# 1. Load cái file ảnh con chuột của mày vào đây (Nhớ sửa lại đường dẫn cho đúng)
	var cursor_image = load("res://assets/ui/mouse_icon.png")
	
	# 2. Ép Windows đổi con trỏ chuột thành cái ảnh đó
	Input.set_custom_mouse_cursor(cursor_image)
