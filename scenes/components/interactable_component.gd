class_name InteractableComponent
extends Area2D

# 1. Khai báo các tín hiệu kích hoạt, hủy kích hoạt và thực hiện tương tác
signal interactable_activated
signal interactable_deactivated
signal interacted # Phát ra khi người chơi nhấn phím tương tác (mặc định là phím E)

var is_player_near: bool = false

func _ready() -> void:
	# 2. Kết nối các sự kiện khi có đối tượng đi vào hoặc rời khỏi vùng tương tác
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	# 3. Kiểm tra nếu đối tượng đi vào là Người chơi (Player)
	if body is Player: 
		is_player_near = true
		interactable_activated.emit()

func _on_body_exited(body: Node2D) -> void:
	# 4. Cập nhật trạng thái khi Người chơi rời khỏi vùng tương tác
	if body is Player:
		is_player_near = false
		interactable_deactivated.emit()

# 5. Xử lý sự kiện nhấn phím tương tác từ người dùng
func _unhandled_input(event: InputEvent) -> void:
	# Chỉ kích hoạt nếu Người chơi đang ở gần và nhấn đúng phím hành động
	if is_player_near and event.is_action_pressed("interact"):
		interacted.emit()
