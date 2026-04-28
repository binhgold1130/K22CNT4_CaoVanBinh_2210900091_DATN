extends CanvasLayer

# --- ĐƯỜNG DẪN & HẰNG SỐ ---
const MAIN_SCENE_PATH = "res://scenes/main_scene.tscn" 
const SAVE_PATH = "user://farm_save.tres"

# --- CÁC NÚT BẤM CHÍNH TỪ VBOXCONTAINER ---
@onready var start_game_button: Button = $MarginContainer/VBoxContainer/StartGameButton
@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton
@onready var exit_game_button: Button = $MarginContainer/VBoxContainer/ExitGameButton
@onready var guide_button: Button = $MarginContainer/VBoxContainer/GuideButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton

# --- CÁC BẢNG (PANELS) VÀ NÚT TẮT ---
@onready var guide_panel: Panel = $GuidePanel
@onready var close_guide_btn: Button = $GuidePanel/CloseGuideButton

@onready var settings_panel: VBoxContainer = $SettingsPanel
@onready var back_settings_btn: Button = $SettingsPanel/BackButton

# --- CÁC THÀNH PHẦN TRONG BẢNG CÀI ĐẶT ---
@onready var fullscreen_check: CheckBox = $SettingsPanel/FullscreenCheck
@onready var resolution_option: OptionButton = $SettingsPanel/ResolutionOption
@onready var volume_slider: HSlider = $SettingsPanel/VolumeSlider

func _ready() -> void:
	# ==========================================
	# TÍNH NĂNG VIP: TỰ ĐỘNG GẮN ÂM THANH HOVER
	# ==========================================
	var all_buttons = [start_game_button, save_game_button, exit_game_button, guide_button, settings_button, close_guide_btn, back_settings_btn, fullscreen_check, resolution_option]
	for btn in all_buttons:
		btn.mouse_entered.connect(func(): AudioManager.play_sfx("ui_hover.ogg"))

	# 1. Tự động kết nối các nút Menu chính (Không cần dùng tab Signals)
	start_game_button.pressed.connect(_on_start_pressed)
	save_game_button.pressed.connect(_on_continue_pressed)
	guide_button.pressed.connect(_on_guide_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_game_button.pressed.connect(_on_exit_pressed)
	
	# 2. Tự động kết nối nút Đóng/Quay lại của các bảng
	close_guide_btn.pressed.connect(_on_close_guide_pressed)
	back_settings_btn.pressed.connect(_on_back_from_settings_pressed)
	
	# 3. Tự động kết nối chức năng trong bảng Cài Đặt 
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	volume_slider.value_changed.connect(_on_volume_changed)
	
	setup_resolution_dropdown()
	
	# Kiểm tra file Save để khóa/mở nút Tiếp tục
	if ResourceLoader.exists(SAVE_PATH):
		save_game_button.disabled = false
	else:
		save_game_button.disabled = true
	
	# Mặc định giấu 2 cái bảng đi khi mới vào sảnh
	guide_panel.hide()
	settings_panel.hide()

# ==========================================
# LOGIC CHUYỂN BẢNG (BẬT/TẮT)
# ==========================================
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

# ==========================================
# LOGIC CHƠI / THOÁT
# ==========================================
func _on_start_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	# Xóa save cũ đi
	if ResourceLoader.exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		
	SaveGameManager.allow_load_on_start = false
	if DayAndNightCycleManager:
		DayAndNightCycleManager.set_time_to(1, 6, 0)
		
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)

func _on_continue_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	SaveGameManager.allow_load_on_start = true
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)

func _on_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	get_tree().quit()

# ==========================================
# LOGIC CÀI ĐẶT (ĐỒ HỌA & ÂM THANH)
# ==========================================
func setup_resolution_dropdown() -> void:
	resolution_option.clear()
	resolution_option.add_item("1280 x 720 (Mặc định)")
	resolution_option.add_item("1920 x 1080 (Full HD)")
	resolution_option.add_item("1024 x 576 (Máy yếu)")
	resolution_option.select(0)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("ui_toggle.ogg")
	if OS.has_feature("editor"):
		fullscreen_check.set_pressed_no_signal(false)
		return
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index: int) -> void:
	AudioManager.play_sfx("ui_toggle.ogg")
	if OS.has_feature("editor"): return
	var screen_size = Vector2(1280, 720)
	if index == 1: screen_size = Vector2(1920, 1080)
	elif index == 2: screen_size = Vector2(1024, 576)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_check.button_pressed = false
	DisplayServer.window_set_size(screen_size)
	
	# Căn cửa sổ ra giữa màn hình
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_center = DisplayServer.screen_get_position(screen_id) + DisplayServer.screen_get_size(screen_id) / 2
	var window_center = DisplayServer.window_get_size() / 2
	DisplayServer.window_set_position(screen_center - window_center)

func _on_volume_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if value <= 0.001:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
