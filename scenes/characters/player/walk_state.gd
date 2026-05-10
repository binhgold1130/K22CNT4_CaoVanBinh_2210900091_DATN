class_name WalkState
extends NodeState

# 1. Khai báo các thành phần điều khiển nhân vật và hoạt ảnh di chuyển
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func physics_process(_delta: float) -> void:
	# 2. Tiếp nhận dữ liệu hướng di chuyển và cập nhật hoạt ảnh tương ứng
	direction = GameInputEvents.movement_input()
	player.set_direction(direction)
	_play_walk_animation(direction)

# 3. Xử lý đầu vào để chuyển sang các trạng thái hành động sử dụng công cụ
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		# Kiểm tra loại công cụ hiện tại để kích hoạt đúng trạng thái (Chặt/Cuốc/Tưới)
		match player.current_tool:
			DataTypes.Tools.AxeWood: transition.emit("chopping")
			DataTypes.Tools.TillGround: transition.emit("tilling")
			DataTypes.Tools.WaterCrops: transition.emit("watering")

func check_transition() -> void:
	# 4. Tự động chuyển về trạng thái Nghỉ (Idle) khi nhân vật dừng di chuyển
	if direction == Vector2.ZERO:
		transition.emit("idle")

func exit() -> void:
	# 5. Dừng mọi hướng di chuyển của nhân vật khi rời khỏi trạng thái
	player.set_direction(Vector2.ZERO)

func _play_walk_animation(dir: Vector2) -> void:
	# 6. Xác định và chạy hoạt ảnh di chuyển dựa trên hướng Vector (Sau, Trước, Phải, Trái)
	var anim_name = ""
	if dir.y < 0: anim_name = "walk_back"
	elif dir.y > 0: anim_name = "walk_front"
	elif dir.x > 0: anim_name = "walk_right"
	elif dir.x < 0: anim_name = "walk_left"
	
	# Chỉ thực hiện đổi hoạt ảnh khi có hướng di chuyển mới và khác với hoạt ảnh cũ
	if anim_name != "" and animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)
