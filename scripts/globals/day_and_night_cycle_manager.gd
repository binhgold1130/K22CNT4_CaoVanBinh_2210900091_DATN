extends Node

# Các tín hiệu báo cho môi trường (đổi màu trời) và UI (hiện đồng hồ)
signal game_time(time: float) # Trả về góc xoay của ánh sáng (radians)
signal time_tick(day: int, hour: int, minute: int)
signal speed_changed(new_speed: float)

const MINUTES_PER_DAY = 1440.0 # 24 tiếng * 60 phút
const MINUTES_PER_HOUR = 60.0

@export var game_speed: float = 1.0 # Tốc độ trôi thời gian (1.0 là mặc định)

var current_day: int = 1
var current_hour: int = 0   # Bắt đầu lúc nửa đêm
var current_minute: int = 0
var total_minutes: float = 0.0 # Tổng thời gian tích lũy (dùng để tính toán mọi thứ)

var is_time_loaded: bool = false 

func _ready() -> void:
	# Mặc định khởi tạo ngày mới nếu không có dữ liệu lưu trữ (Save game)
	if not is_time_loaded:
		set_time_to(1, 0, 0)

# Hàm ép thời gian về một mốc cụ thể (ví dụ: dùng khi ngủ dậy sáng hôm sau)
func set_time_to(day: int, hour: int, minute: int) -> void:
	total_minutes = (day - 1) * MINUTES_PER_DAY + (hour * MINUTES_PER_HOUR) + minute
	_update_time_logic()

# Hàm nạp thời gian từ file đã lưu (Save file)
func load_saved_time(saved_total_minutes: float) -> void:
	total_minutes = saved_total_minutes
	is_time_loaded = true
	_update_time_logic()

func _process(delta: float) -> void:
	# Thời gian trôi liên tục dựa trên game_speed
	total_minutes += delta * game_speed
	_update_time_logic()

func _update_time_logic() -> void:
	# 1. Xử lý ánh sáng (ColorRect hoặc DirectionalLight2D sẽ dùng giá trị này để đổi màu trời)
	var current_time_in_day = fmod(total_minutes, MINUTES_PER_DAY)
	var time_in_radians = (current_time_in_day / MINUTES_PER_DAY) * TAU # Chuyển về góc vòng tròn
	game_time.emit(time_in_radians)
	
	# 2. Chuyển đổi tổng số phút ra Ngày:Giờ:Phút để hiển thị lên màn hình
	var total_m = int(total_minutes)
	var new_day = (total_m / int(MINUTES_PER_DAY)) + 1
	var new_hour = (total_m % int(MINUTES_PER_DAY)) / int(MINUTES_PER_HOUR)
	var new_minute = total_m % int(MINUTES_PER_HOUR)
	
	# Chỉ phát tín hiệu cập nhật UI khi "Số phút" thực sự thay đổi để tránh lag
	if new_minute != current_minute:
		current_day = new_day
		current_hour = new_hour
		current_minute = new_minute
		time_tick.emit(current_day, current_hour, current_minute)

# Chỉnh thời gian trôi nhanh/chậm (ví dụ: đứng yên thì trôi chậm, ngủ thì trôi nhanh)
func set_game_speed(speed: float) -> void:
	game_speed = speed
	speed_changed.emit(game_speed)
