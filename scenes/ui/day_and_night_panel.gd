extends Control

# 1. Khai báo các nhãn hiển thị ngày và giờ trên giao diện người dùng
@onready var day_label: Label = $DayPanel/MarginContainer/Label
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

# 2. Khai báo các nút điều khiển tốc độ thời gian (Bình thường, Nhanh, Siêu nhanh)
@onready var normal_btn: Button = $Control/NormalSpeedButton
@onready var fast_btn: Button = $Control/FastSpeedButton
@onready var cheetah_btn: Button = $Control/CheetahSpeedButton

func _ready() -> void:
	# 3. Kết nối tín hiệu cập nhật thời gian từ trình quản lý chu kỳ Ngày/Đêm (Autoload)
	DayAndNightCycleManager.time_tick.connect(_on_time_tick)
	
	# 4. Thiết lập sự kiện nhấn nút để thay đổi tốc độ trôi của thời gian trong game
	normal_btn.pressed.connect(func(): DayAndNightCycleManager.set_game_speed(1.0))
	fast_btn.pressed.connect(func(): DayAndNightCycleManager.set_game_speed(50.0))
	cheetah_btn.pressed.connect(func(): DayAndNightCycleManager.set_game_speed(100.0))

func _on_time_tick(day: int, hour: int, minute: int) -> void:
	# 5. Cập nhật văn bản hiển thị số ngày hiện tại
	day_label.text = "Ngày " + str(day)
	
	# 6. Định dạng và hiển thị thời gian theo kiểu HH:MM (ví dụ: 08:05)
	var hh = str(hour).pad_zeros(2)
	var mm = str(minute).pad_zeros(2)
	time_label.text = hh + ":" + mm
