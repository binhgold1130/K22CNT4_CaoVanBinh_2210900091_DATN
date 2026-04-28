class_name GameInputEvents
extends Node

static func movement_input() -> Vector2:
	# Thêm .normalized() để vận tốc luôn đồng nhất 1 đơn vị
	return Input.get_vector("walk_left","walk_right","walk_up","walk_down").normalized()

static func is_movement_input() -> bool:
	return movement_input() != Vector2.ZERO

static func use_tool() -> bool:
	return Input.is_action_just_pressed("hit")
