extends Node

# Biến này để Main Menu báo cho Main Scene biết là "Ê, load game cho tao!"
var allow_load_on_start: bool = false

# 1. Tạo 2 cái "Loa phát thanh" (Signals)
signal save_game
signal load_game

# 2. Chuyển phần nhận phím tắt về đây quản lý tập trung
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_O: 
			print("📢 [Global] Đã phát lệnh LƯU GAME!")
			save_game.emit() # Phát loa!
		elif event.keycode == KEY_P: 
			print("📢 [Global] Đã phát lệnh TẢI GAME!")
			load_game.emit() # Phát loa!
