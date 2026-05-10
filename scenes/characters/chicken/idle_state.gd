class_name ChickenIdleState
extends NodeState

# 1. Khai báo các thành phần điều khiển hoạt ảnh và âm thanh của gà
@export var animated_sprite_2d: AnimatedSprite2D
@export var voice_player: AudioStreamPlayer2D # Hệ thống âm thanh 2D (âm lượng giảm dần theo khoảng cách)

# 2. Thiết lập cấu hình thời gian đứng im (Idle)
@export var min_idle_time: float = 2.0
@export var max_idle_time: float = 5.0

var idle_timer: float = 0.0

func _ready() -> void:
	# Khởi tạo thời gian chờ ngẫu nhiên khi bắt đầu
	idle_timer = randf_range(0.5, max_idle_time)

func enter() -> void:
	# 3. Logic khi bắt đầu vào trạng thái Đứng im
	idle_timer = randf_range(min_idle_time, max_idle_time)
	
	if animated_sprite_2d:
		animated_sprite_2d.play("idle") # Chạy hoạt ảnh đứng im
		animated_sprite_2d.flip_h = randf() > 0.5 # Ngẫu nhiên lật hình ảnh theo chiều ngang
		
	# 4. Xác suất 30% gà tự phát ra tiếng kêu
	if randi() % 100 < 30:
		if voice_player != null and not voice_player.playing:
			voice_player.play()

func exit() -> void:
	pass

func process(delta: float) -> void:
	# 5. Đếm ngược bộ thời gian chờ
	if idle_timer > 0:
		idle_timer -= delta

func check_transition() -> void:
	# 6. Chuyển sang trạng thái Di chuyển (Walk) khi hết thời gian chờ
	if idle_timer <= 0:
		transition.emit("walk")
