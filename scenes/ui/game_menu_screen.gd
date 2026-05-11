class_name MainMenu
extends CanvasLayer

# 1. Khai báo các đường dẫn tài nguyên và file lưu trữ game
const MAIN_SCENE_PATH = "res://scenes/main_scene.tscn" 
const SAVE_PATH = "user://farm_save.tres"

# 2. Khai báo các nút bấm chính tại màn hình chờ
@onready var start_game_button: Button = $MarginContainer/VBoxContainer/StartGameButton
@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton
@onready var exit_game_button: Button = $MarginContainer/VBoxContainer/ExitGameButton
@onready var guide_button: Button = $MarginContainer/VBoxContainer/GuideButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton

# 3. Khai báo các bảng hướng dẫn, cài đặt và nút điều hướng tương ứng
@onready var guide_panel: Panel = $GuidePanel
@onready var close_guide_btn: Button = $GuidePanel/CloseGuideButton

@onready var settings_panel: VBoxContainer = $SettingsPanel
@onready var back_settings_btn: Button = $SettingsPanel/BackButton

# 4. Khai báo các thành phần điều chỉnh thông số trong bảng Cài đặt
@onready var fullscreen_check: CheckBox = $SettingsPanel/FullscreenCheck
@onready var resolution_option: OptionButton = $SettingsPanel/ResolutionOption
@onready var volume_slider: HSlider = $SettingsPanel/VolumeSlider

func _ready() -> void:
	# 5. Tự động gắn hiệu ứng âm thanh khi di chuyển chuột qua các nút bấm
	var all_buttons = [start_game_button, save_game_button, exit_game_button, guide_button, settings_button, close_guide_btn, back_settings_btn, fullscreen_check, resolution_option]
	for btn in all_buttons:
		btn.mouse_entered.connect(func(): AudioManager.play_sfx("ui_hover.ogg"))

	# 6. Kết nối các sự kiện nhấn nút cho hệ thống Menu chính
	start_game_button.pressed.connect(_on_start_pressed)
	save_game_button.pressed.connect(_on_continue_pressed)
	guide_button.pressed.connect(_on_guide_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_game_button.pressed.connect(_on_exit_pressed)
	
	# 7. Kết nối các nút Đóng/Quay lại cho các bảng chức năng
	close_guide_btn.pressed.connect(_on_close_guide_pressed)
	back_settings_btn.pressed.connect(_on_back_from_settings_pressed)
	
	# 8. Thiết lập các trình điều khiển trong bảng Cài đặt
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	volume_slider.value_changed.connect(_on_volume_changed)
	
	setup_resolution_dropdown()
	
	# 9. Kiểm tra sự tồn tại của file save để cập nhật trạng thái nút "Tiếp tục"
	if ResourceLoader.exists(SAVE_PATH):
		save_game_button.disabled = false
	else:
		save_game_button.disabled = true
	
	# Khởi tạo trạng thái ẩn cho các bảng phụ khi vào màn hình chính
	guide_panel.hide()
	settings_panel.hide()

# 10. Xử lý logic hiển thị/ẩn bảng Hướng dẫn và Cài đặt
func _on_guide_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	guide_panel.show()

func _on_close_guide_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	guide_panel.hide()

func _on_settings_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	settings_panel.show()

func _on_back_from_settings_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	settings_panel.hide()

# 11. Xử lý logic bắt đầu trò chơi mới (Xóa save cũ nếu có)
func _on_start_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	if ResourceLoader.exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		
	SaveGameManager.allow_load_on_start = false
	if DayAndNightCycleManager:
		DayAndNightCycleManager.set_time_to(DayAndNightCycleManager.start_day,
		DayAndNightCycleManager.start_hour, DayAndNightCycleManager.start_minute) 
		
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)

# 12. Xử lý logic tiếp tục trò chơi từ file lưu trữ
func _on_continue_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	SaveGameManager.allow_load_on_start = true # Bật cờ cho phép nạp dữ liệu khi vào scene
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)

func _on_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	get_tree().quit()

# 13. Cấu hình các tùy chọn độ phân giải màn hình
func setup_resolution_dropdown() -> void:
	resolution_option.clear()
	resolution_option.add_item("1280 x 720 (Mặc định)")
	resolution_option.add_item("1920 x 1080 (Full HD)")
	resolution_option.add_item("1024 x 576 (Máy yếu)")
	resolution_option.select(0)

# 14. Điều chỉnh chế độ hiển thị Toàn màn hình
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("ui_toggle.ogg")
	if OS.has_feature("editor"):
		fullscreen_check.set_pressed_no_signal(false)
		return
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# 15. Thay đổi độ phân giải và căn giữa cửa sổ
func _on_resolution_selected(index: int) -> void:
	AudioManager.play_sfx("ui_toggle.ogg")
	if OS.has_feature("editor"): return
	var screen_size = Vector2(1280, 720)
	if index == 1: screen_size = Vector2(1920, 1080)
	elif index == 2: screen_size = Vector2(1024, 576)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_check.button_pressed = false
	DisplayServer.window_set_size(screen_size)
	
	# Tính toán vị trí để đưa cửa sổ vào chính giữa màn hình người dùng
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_center = DisplayServer.screen_get_position(screen_id) + DisplayServer.screen_get_size(screen_id) / 2
	var window_center = DisplayServer.window_get_size() / 2
	DisplayServer.window_set_position(screen_center - window_center)

# 16. Quản lý âm lượng tổng và trạng thái Mute
func _on_volume_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if value <= 0.001:
		AudioServer.set_bus_volume_db(bus_index, -80.0) # Ép âm lượng xuống mức thấp nhất
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
