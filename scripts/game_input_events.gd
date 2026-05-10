class_name GameInputEvents
extends Node

# 1. Lấy vector hướng di chuyển dựa trên các phím điều hướng của người chơi
static func movement_input() -> Vector2:
	# 2. Thêm .normalized() để vận tốc luôn đồng nhất 1 đơn vị, tránh lỗi đi chéo bị nhanh hơn
	return Input.get_vector("walk_left","walk_right","walk_up","walk_down").normalized()

# 3. Kiểm tra xem người chơi có đang thực hiện thao tác di chuyển hay không
static func is_movement_input() -> bool:
	return movement_input() != Vector2.ZERO

# 4. Bắt sự kiện người chơi vừa nhấn phím hành động để sử dụng công cụ (ví dụ: cuốc đất, chặt cây)
static func use_tool() -> bool:
	return Input.is_action_just_pressed("hit")
