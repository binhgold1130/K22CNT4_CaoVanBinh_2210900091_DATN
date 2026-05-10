class_name TillingState
extends NodeState

# 1. Khai báo các thành phần điều khiển nhân vật và hoạt ảnh cuốc đất
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 = Vector2.DOWN

func enter() -> void:
	# 2. Xử lý khi bắt đầu vào trạng thái Cuốc đất
	# Lấy hướng quay mặt cuối cùng của người chơi để thực hiện hành động
	direction = player.last_direction

	# Dừng vận tốc nhân vật để cố định vị trí khi làm việc
	player.velocity = Vector2.ZERO

	_play_till_animation() # Kích hoạt hoạt ảnh tương ứng


func physics_process(_delta: float) -> void:
	# 3. Đảm bảo nhân vật đứng yên tuyệt đối trong quá trình vật lý
	player.velocity = Vector2.ZERO
	player.move_and_slide()


func check_transition() -> void:
	# 4. Chuyển về trạng thái Nghỉ (Idle) ngay khi kết thúc hoạt ảnh
	if not animated_sprite_2d.is_playing():
		transition.emit("idle")


# 5. Phân loại hướng để chạy đúng hoạt ảnh Cuốc đất (Sau, Trước, Phải, Trái)
func _play_till_animation():
	if direction.y < 0:
		animated_sprite_2d.play("tilling_back")
	elif direction.y > 0:
		animated_sprite_2d.play("tilling_front")
	elif direction.x > 0:
		animated_sprite_2d.play("tilling_right")
	elif direction.x < 0:
		animated_sprite_2d.play("tilling_left")
