class_name IdleState
extends NodeState

# 1. Khai báo các thành phần điều khiển nhân vật và hoạt ảnh đứng im
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func enter() -> void:
	# 2. Kích hoạt hoạt ảnh đứng im ngay khi bắt đầu vào trạng thái
	play_idle_animation()

# 3. Xử lý sự kiện đầu vào để chuyển đổi sang các trạng thái sử dụng công cụ
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		# Kiểm tra loại công cụ đang trang bị để chuyển sang State hành động tương ứng
		match player.current_tool:
			DataTypes.Tools.AxeWood: transition.emit("chopping")
			DataTypes.Tools.TillGround: transition.emit("tilling")
			DataTypes.Tools.WaterCrops: transition.emit("watering")

func physics_process(_delta: float) -> void:
	# 4. Cập nhật hướng nhìn của nhân vật dựa trên tín hiệu di chuyển từ người chơi
	direction = GameInputEvents.movement_input()
	if direction != Vector2.ZERO:
		player.set_direction(direction)
		play_idle_animation()

func check_transition() -> void:
	# 5. Chuyển sang trạng thái Di chuyển (Walk) nếu phát hiện có đầu vào hướng
	if direction != Vector2.ZERO:
		transition.emit("walk")

func play_idle_animation() -> void:
	# 6. Phân loại và chạy hoạt ảnh đứng im dựa trên hướng nhìn cuối cùng (last_direction)
	var dir = player.last_direction
	if dir.y < 0: animated_sprite_2d.play("idle_back")
	elif dir.y > 0: animated_sprite_2d.play("idle_front")
	elif dir.x > 0: animated_sprite_2d.play("idle_right")
	elif dir.x < 0: animated_sprite_2d.play("idle_left")
