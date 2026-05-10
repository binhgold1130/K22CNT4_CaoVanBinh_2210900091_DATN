# res://scenes/ui/tools_panel.gd
extends PanelContainer

# 1. Khai báo từ điển ánh xạ giữa loại công cụ và các nút bấm tương ứng trên giao diện
@onready var buttons: Dictionary = {
	DataTypes.Tools.AxeWood: $MarginContainer/HBoxContainer/ToolAxe,
	DataTypes.Tools.TillGround: $MarginContainer/HBoxContainer/ToolTilling,
	DataTypes.Tools.WaterCrops: $MarginContainer/HBoxContainer/ToolWateringCan,
	DataTypes.Tools.PlantCorn: $MarginContainer/HBoxContainer/ToolCorn,
	DataTypes.Tools.PlantTomato: $MarginContainer/HBoxContainer/ToolTomato
}

# 2. Khai báo các nhãn hiển thị số lượng hạt giống còn lại
@onready var corn_count_label: Label = $MarginContainer/HBoxContainer/ToolCorn/CornLabel
@onready var tomato_count_label: Label = $MarginContainer/HBoxContainer/ToolTomato/TomatoLabel

func _ready() -> void:
	# 3. Kết nối tín hiệu để cập nhật giao diện khi chọn công cụ hoặc thay đổi kho đồ
	ToolManager.tool_selected.connect(_update_ui_highlight)
	InventoryManager.inventory_updated.connect(_update_seed_counts)
	
	# 4. Khởi tạo trạng thái và kết nối sự kiện nhấn cho từng nút công cụ
	for tool in buttons:
		buttons[tool].disabled = false
		buttons[tool].pressed.connect(_on_tool_pressed.bind(tool))

	_update_seed_counts()

func _update_ui_highlight(selected_tool: DataTypes.Tools) -> void:
	# 5. Cập nhật hiệu ứng làm nổi bật (Highlight) công cụ đang được chọn
	for key in buttons:
		buttons[key].modulate = Color.WHITE # Đặt lại màu trắng mặc định cho tất cả
		
	if selected_tool != DataTypes.Tools.None and buttons.has(selected_tool):
		buttons[selected_tool].modulate = Color.YELLOW # Chuyển sang màu vàng cho công cụ được chọn

func _on_tool_pressed(tool: DataTypes.Tools) -> void:
	# 6. Xử lý logic chọn hoặc bỏ chọn công cụ khi nhấn nút
	if ToolManager.selected_tool == tool:
		ToolManager.select_tool(DataTypes.Tools.None) # Nếu nhấn lại công cụ đang chọn thì bỏ chọn
	else:
		ToolManager.select_tool(tool) # Chọn công cụ mới

func _update_seed_counts() -> void:
	# 7. Cập nhật hiển thị số lượng hạt giống và đổi màu cảnh báo nếu hết hàng
	var corn_qty = InventoryManager.get_item_count("corn_seed")
	var tomato_qty = InventoryManager.get_item_count("tomato_seed")
	
	if corn_count_label:
		corn_count_label.text = str(corn_qty)
		if corn_qty <= 0:
			corn_count_label.modulate = Color.RED # Màu đỏ nếu hết hạt giống
		else:
			corn_count_label.modulate = Color.WHITE
			
	if tomato_count_label:
		tomato_count_label.text = str(tomato_qty)
		if tomato_qty <= 0:
			tomato_count_label.modulate = Color.RED
		else:
			tomato_count_label.modulate = Color.WHITE


func _on_settings_button_pressed() -> void:
	# 8. Xử lý mở trình đơn tạm dừng (Pause Menu) và phát âm thanh hiệu ứng
	AudioManager.play_sfx("ui_click.ogg")
	# Truy xuất và kích hoạt trạng thái tạm dừng từ PauseMenu
	$"../../../PauseMenu".toggle_pause()
