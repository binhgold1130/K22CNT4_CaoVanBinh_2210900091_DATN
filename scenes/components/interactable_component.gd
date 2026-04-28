class_name InteractableComponent
extends Area2D

signal interactable_activated
signal interactable_deactivated
signal interacted # 🔥 Tín hiệu mới: Phát ra khi người chơi bấm E

var is_player_near: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player: # Chỉ nhận diện Player, tránh gà bò đi ngang cũng tương tác
		is_player_near = true
		interactable_activated.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_near = false
		interactable_deactivated.emit()

# Hàm bắt sự kiện bấm phím
func _unhandled_input(event: InputEvent) -> void:
	# Nếu Player đang đứng gần VÀ bấm phím hành động (E)
	if is_player_near and event.is_action_pressed("interact"):
		interacted.emit()
