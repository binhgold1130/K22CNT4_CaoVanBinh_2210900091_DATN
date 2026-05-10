class_name CowIdleState
extends NodeState

# 1. Khai báo thành phần điều khiển hoạt ảnh và âm thanh cho bò
@export var animated_sprite_2d: AnimatedSprite2D
@export var voice_player: AudioStreamPlayer2D # Hệ thống loa 2D hỗ trợ giảm âm lượng theo khoảng cách

# 2. Cấu hình thời gian đứng im (Idle)
@export var min_idle_time: float = 4.0 
@export var max_idle_time: float = 8.0

var idle_timer: float = 0.0

func _ready() -> void:
	# Khởi tạo thời gian chờ ngẫu nhiên ban đầu
	idle_timer = randf_range(0.5, max_idle_time)

func enter() -> void:
	# 3. Thiết lập thời gian nghỉ và chạy hoạt ảnh khi vào trạng thái
	idle_timer = randf_range(min_idle_time, max_idle_time)
	
	if animated_sprite_2d:
		if randf() > 0.3:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("idle") 
			
		animated_sprite_2d.flip_h = randf() > 0.5 # Ngẫu nhiên lật hình ảnh nhân vật
		
	# 4. Xác suất 30% bò phát ra tiếng kêu ngẫu nhiên
	if randi() % 100 < 30:
		if voice_player != null and not voice_player.playing:
			voice_player.play()

func exit() -> void:
	pass

func process(delta: float) -> void:
	# 5. Cập nhật bộ đếm thời gian chờ
	if idle_timer > 0:
		idle_timer -= delta

func check_transition() -> void:
	# 6. Chuyển sang trạng thái Di chuyển (Walk) sau khi hết thời gian chờ
	if idle_timer <= 0:
		transition.emit("walk")
