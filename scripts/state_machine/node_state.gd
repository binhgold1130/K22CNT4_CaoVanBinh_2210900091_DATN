class_name NodeState
extends Node

# 1. Tín hiệu dùng để thông báo cho State Machine chuyển sang một trạng thái mới
signal transition(new_state_name: String)

# 2. Hàm được gọi một lần duy nhất khi bắt đầu đi vào trạng thái này
func enter() -> void:
	pass

# 3. Hàm được gọi một lần duy nhất khi thoát khỏi trạng thái này để dọn dẹp
func exit() -> void:
	pass

# 4. Hàm xử lý logic cập nhật liên tục mỗi khung hình (tương đương _process)
func process(_delta: float) -> void:
	pass

# 5. Hàm xử lý các tính toán vật lý cố định (tương đương _physics_process)
func physics_process(_delta: float) -> void:
	pass

# 6. Hàm liên tục kiểm tra các điều kiện để quyết định việc chuyển đổi trạng thái
func check_transition() -> void:
	pass

# 7. Hàm bắt và xử lý các sự kiện đầu vào (Input Event) từ người chơi
func handle_input(_event: InputEvent) -> void:
	pass
