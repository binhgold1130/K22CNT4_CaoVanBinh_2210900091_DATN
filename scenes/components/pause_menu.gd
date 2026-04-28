extends CanvasLayer

@onready var main_panel: VBoxContainer = $CenterContainer/MainPanel
@onready var confirm_panel: VBoxContainer = $CenterContainer/ConfirmPanel
@onready var settings_panel: VBoxContainer = $CenterContainer/SettingsPanel

# Nút MainPanel
@onready var resume_btn: Button = $CenterContainer/MainPanel/ResumeButton
@onready var settings_btn: Button = $CenterContainer/MainPanel/SettingsButton
@onready var exit_btn: Button = $CenterContainer/MainPanel/ExitButton

# Nút ConfirmPanel
@onready var save_exit_btn: Button = $CenterContainer/ConfirmPanel/HBoxContainer/SaveExitButton
@onready var just_exit_btn: Button = $CenterContainer/ConfirmPanel/HBoxContainer/JustExitButton
@onready var cancel_btn: Button = $CenterContainer/ConfirmPanel/HBoxContainer/CancelButton

# Nút SettingsPanel (CÀI ĐẶT)
@onready var fullscreen_check: CheckBox = $CenterContainer/SettingsPanel/FullscreenCheck
@onready var resolution_option: OptionButton = $CenterContainer/SettingsPanel/ResolutionOption
@onready var volume_slider: HSlider = $CenterContainer/SettingsPanel/VolumeSlider
@onready var back_btn: Button = $CenterContainer/SettingsPanel/BackButton

func _ready() -> void:
	# ==========================================
	# TÍNH NĂNG VIP: TỰ ĐỘNG GẮN ÂM THANH HOVER
	# ==========================================
	var all_buttons = [resume_btn, settings_btn, exit_btn, save_exit_btn, just_exit_btn, cancel_btn, back_btn, fullscreen_check, resolution_option]
	for btn in all_buttons:
		btn.mouse_entered.connect(func(): AudioManager.play_sfx("ui_hover.ogg"))

	# 1. Kết nối Menu Chính
	resume_btn.pressed.connect(toggle_pause)
	settings_btn.pressed.connect(_on_settings_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)
	
	# 2. Kết nối Bảng Thoát
	save_exit_btn.pressed.connect(_on_save_and_exit_pressed)
	just_exit_btn.pressed.connect(_on_just_exit_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)
	
	# 3. Kết nối Bảng Cài Đặt
	back_btn.pressed.connect(_on_back_from_settings_pressed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	volume_slider.value_changed.connect(_on_volume_changed)
	
	setup_resolution_dropdown()
	
	# Mặc định ẩn Menu khi mới vào game
	hide()
	confirm_panel.hide()
	settings_panel.hide()
	main_panel.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): 
		toggle_pause()

func toggle_pause() -> void:
	AudioManager.play_sfx("ui_click.ogg") 
	visible = !visible
	get_tree().paused = visible 
	
	if visible:
		main_panel.show()
		confirm_panel.hide()
		settings_panel.hide()

# ==========================================
# GIAO DIỆN CHUYỂN BẢNG
# ==========================================
func _on_settings_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	main_panel.hide()
	settings_panel.show()

func _on_back_from_settings_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	settings_panel.hide()
	main_panel.show()

func _on_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	main_panel.hide()
	confirm_panel.show()

func _on_cancel_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	confirm_panel.hide()
	main_panel.show()

# ==========================================
# CHỨC NĂNG LƯU / THOÁT
# ==========================================
func _on_save_and_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	SaveGameManager.save_game.emit()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")

func _on_just_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")

# ==========================================
# CHỨC NĂNG CÀI ĐẶT (ĐỒ HỌA & ÂM THANH)
# ==========================================
func setup_resolution_dropdown() -> void:
	resolution_option.add_item("1280 x 720 (Mặc định)")
	resolution_option.add_item("1920 x 1080 (Full HD)")
	resolution_option.add_item("1024 x 576 (Máy yếu)")
	resolution_option.select(0) 

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("ui_toggle.ogg") 
	
	if OS.has_feature("editor"):
		print("========================================")
		print("[DEV MODE] Tính năng Fullscreen tạm khóa để chống Crash.")
		print("========================================")
		fullscreen_check.set_pressed_no_signal(false) 
		return 
		
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index: int) -> void:
	AudioManager.play_sfx("ui_toggle.ogg") 
	
	if OS.has_feature("editor"):
		print("========================================")
		print("[DEV MODE] Tính năng Đổi Độ Phân Giải tạm khóa để chống Crash.")
		print("========================================")
		return

	var screen_size = Vector2(1280, 720)
	
	if index == 0: screen_size = Vector2(1280, 720)
	elif index == 1: screen_size = Vector2(1920, 1080)
	elif index == 2: screen_size = Vector2(1024, 576)
		
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_check.button_pressed = false 
	DisplayServer.window_set_size(screen_size)
	
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_center = DisplayServer.screen_get_position(screen_id) + DisplayServer.screen_get_size(screen_id) / 2
	var window_center = DisplayServer.window_get_size() / 2
	DisplayServer.window_set_position(screen_center - window_center)

func _on_volume_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	
	if value <= 0.001:
		# Kéo kịch thanh: Ép xuống -80dB (ngưỡng điếc) để nó mờ đi êm ái
		AudioServer.set_bus_volume_db(bus_index, -80.0)
		# Sau khi đã câm hẳn thì bật Mute để tiết kiệm CPU không xử lý luồng âm thanh đó nữa
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		# Chuẩn sách giáo khoa: Dùng hàm linear_to_db nguyên gốc
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
