extends CanvasLayer

# 1. Khai báo các bảng điều khiển trong menu (Main, Confirm, Settings)
@onready var main_panel: VBoxContainer = $CenterContainer/MainPanel
@onready var confirm_panel: VBoxContainer = $CenterContainer/ConfirmPanel
@onready var settings_panel: VBoxContainer = $CenterContainer/SettingsPanel

# 2. Khai báo các nút bấm chức năng
@onready var resume_btn: Button = $CenterContainer/MainPanel/ResumeButton
@onready var settings_btn: Button = $CenterContainer/MainPanel/SettingsButton
@onready var exit_btn: Button = $CenterContainer/MainPanel/ExitButton

@onready var save_exit_btn: Button = $CenterContainer/ConfirmPanel/HBoxContainer/SaveExitButton
@onready var just_exit_btn: Button = $CenterContainer/ConfirmPanel/HBoxContainer/JustExitButton
@onready var cancel_btn: Button = $CenterContainer/ConfirmPanel/HBoxContainer/CancelButton

@onready var fullscreen_check: CheckBox = $CenterContainer/SettingsPanel/FullscreenCheck
@onready var resolution_option: OptionButton = $CenterContainer/SettingsPanel/ResolutionOption
@onready var volume_slider: HSlider = $CenterContainer/SettingsPanel/VolumeSlider
@onready var back_btn: Button = $CenterContainer/SettingsPanel/BackButton

func _ready() -> void:
	# 3. Tự động gắn hiệu ứng âm thanh khi rê chuột qua các nút
	var all_buttons = [resume_btn, settings_btn, exit_btn, save_exit_btn, just_exit_btn, cancel_btn, back_btn, fullscreen_check, resolution_option]
	for btn in all_buttons:
		btn.mouse_entered.connect(func(): AudioManager.play_sfx("ui_hover.ogg"))

	# 4. Kết nối các sự kiện nhấn nút cho từng bảng chức năng
	resume_btn.pressed.connect(toggle_pause)
	settings_btn.pressed.connect(_on_settings_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)
	
	save_exit_btn.pressed.connect(_on_save_and_exit_pressed)
	just_exit_btn.pressed.connect(_on_just_exit_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)
	
	back_btn.pressed.connect(_on_back_from_settings_pressed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	volume_slider.value_changed.connect(_on_volume_changed)
	
	setup_resolution_dropdown()
	
	# 5. Khởi tạo trạng thái ẩn/hiện mặc định của UI khi vào game
	hide()
	confirm_panel.hide()
	settings_panel.hide()
	main_panel.show()

func _unhandled_input(event: InputEvent) -> void:
	# 6. Lắng nghe phím ESC (ui_cancel) để bật/tắt Menu
	if event.is_action_pressed("ui_cancel"): 
		toggle_pause()

func toggle_pause() -> void:
	# 7. Xử lý logic tạm dừng game và hiển thị Menu
	AudioManager.play_sfx("ui_click.ogg") 
	visible = !visible
	get_tree().paused = visible 
	
	if visible:
		main_panel.show()
		confirm_panel.hide()
		settings_panel.hide()

# 8. Xử lý chuyển đổi qua lại giữa các bảng điều khiển
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

# 9. Xử lý logic Lưu dữ liệu và Thoát game
func _on_save_and_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	SaveGameManager.save_game.emit() # Phát tín hiệu lưu game
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")

func _on_just_exit_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")

# 10. Cấu hình các lựa chọn độ phân giải màn hình
func setup_resolution_dropdown() -> void:
	resolution_option.add_item("1280 x 720 (Mặc định)")
	resolution_option.add_item("1920 x 1080 (Full HD)")
	resolution_option.add_item("1024 x 576 (Máy yếu)")
	resolution_option.select(0) 

# 11. Xử lý thay đổi chế độ Toàn màn hình (Fullscreen)
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("ui_toggle.ogg") 
	
	if OS.has_feature("editor"):
		# Chống Crash khi đang chạy trong trình biên tập (Editor)
		fullscreen_check.set_pressed_no_signal(false) 
		return 
		
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# 12. Xử lý thay đổi độ phân giải và căn giữa cửa sổ
func _on_resolution_selected(index: int) -> void:
	AudioManager.play_sfx("ui_toggle.ogg") 
	
	if OS.has_feature("editor"):
		return

	var screen_size = Vector2(1280, 720)
	if index == 0: screen_size = Vector2(1280, 720)
	elif index == 1: screen_size = Vector2(1920, 1080)
	elif index == 2: screen_size = Vector2(1024, 576)
		
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_check.button_pressed = false 
	DisplayServer.window_set_size(screen_size)
	
	# Căn giữa cửa sổ trên màn hình hiện tại
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_center = DisplayServer.screen_get_position(screen_id) + DisplayServer.screen_get_size(screen_id) / 2
	var window_center = DisplayServer.window_get_size() / 2
	DisplayServer.window_set_position(screen_center - window_center)

# 13. Điều chỉnh âm lượng hệ thống
func _on_volume_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	
	if value <= 0.001:
		# Tắt âm hoàn toàn và ngắt xử lý Bus để tiết kiệm tài nguyên
		AudioServer.set_bus_volume_db(bus_index, -80.0)
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		# Chuyển đổi giá trị tuyến tính sang Decibel
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
