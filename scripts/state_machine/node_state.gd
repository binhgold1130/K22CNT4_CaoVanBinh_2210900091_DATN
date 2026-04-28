class_name NodeState
extends Node

signal transition(new_state_name: String)

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func check_transition() -> void:
	pass

# 🔥 Hàm mới để xử lý Input Event
func handle_input(_event: InputEvent) -> void:
	pass
