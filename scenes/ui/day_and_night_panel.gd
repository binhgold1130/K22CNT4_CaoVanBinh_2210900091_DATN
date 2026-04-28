extends Control

@onready var day_label: Label = $DayPanel/MarginContainer/Label
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

@onready var normal_btn: Button = $Control/NormalSpeedButton
@onready var fast_btn: Button = $Control/FastSpeedButton
@onready var cheetah_btn: Button = $Control/CheetahSpeedButton

func _ready() -> void:
	# Kết nối signal từ Manager
	DayAndNightCycleManager.time_tick.connect(_on_time_tick)
	
	# Kết nối nút bấm tốc độ
	normal_btn.pressed.connect(func(): DayAndNightCycleManager.set_game_speed(1.0))
	fast_btn.pressed.connect(func(): DayAndNightCycleManager.set_game_speed(50.0))
	cheetah_btn.pressed.connect(func(): DayAndNightCycleManager.set_game_speed(100.0))

func _on_time_tick(day: int, hour: int, minute: int) -> void:
	# Cập nhật Label ngày
	day_label.text = "Ngày " + str(day)
	
	# Định dạng thời gian HH:MM (ví dụ: 08:05)
	var hh = str(hour).pad_zeros(2)
	var mm = str(minute).pad_zeros(2)
	time_label.text = hh + ":" + mm
