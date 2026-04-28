# res://scenes/ui/tools_panel.gd
extends PanelContainer

@onready var buttons: Dictionary = {
	DataTypes.Tools.AxeWood: $MarginContainer/HBoxContainer/ToolAxe,
	DataTypes.Tools.TillGround: $MarginContainer/HBoxContainer/ToolTilling,
	DataTypes.Tools.WaterCrops: $MarginContainer/HBoxContainer/ToolWateringCan,
	DataTypes.Tools.PlantCorn: $MarginContainer/HBoxContainer/ToolCorn,
	DataTypes.Tools.PlantTomato: $MarginContainer/HBoxContainer/ToolTomato
}

@onready var corn_count_label: Label = $MarginContainer/HBoxContainer/ToolCorn/CornLabel
@onready var tomato_count_label: Label = $MarginContainer/HBoxContainer/ToolTomato/TomatoLabel

func _ready() -> void:
	ToolManager.tool_selected.connect(_update_ui_highlight)
	InventoryManager.inventory_updated.connect(_update_seed_counts)
	
	for tool in buttons:
		buttons[tool].disabled = false
		buttons[tool].pressed.connect(_on_tool_pressed.bind(tool))

	_update_seed_counts()

func _update_ui_highlight(selected_tool: DataTypes.Tools) -> void:
	for key in buttons:
		buttons[key].modulate = Color.WHITE
		
	if selected_tool != DataTypes.Tools.None and buttons.has(selected_tool):
		buttons[selected_tool].modulate = Color.YELLOW

func _on_tool_pressed(tool: DataTypes.Tools) -> void:
	if ToolManager.selected_tool == tool:
		ToolManager.select_tool(DataTypes.Tools.None)
	else:
		ToolManager.select_tool(tool)

func _update_seed_counts() -> void:
	# [ĐÃ SỬA] Đọc dữ liệu từ biến _seed
	var corn_qty = InventoryManager.get_item_count("corn_seed")
	var tomato_qty = InventoryManager.get_item_count("tomato_seed")
	
	if corn_count_label:
		corn_count_label.text = str(corn_qty)
		if corn_qty <= 0:
			corn_count_label.modulate = Color.RED
		else:
			corn_count_label.modulate = Color.WHITE
			
	if tomato_count_label:
		tomato_count_label.text = str(tomato_qty)
		if tomato_qty <= 0:
			tomato_count_label.modulate = Color.RED
		else:
			tomato_count_label.modulate = Color.WHITE


func _on_settings_button_pressed() -> void:
	AudioManager.play_sfx("ui_click.ogg")
	# Gọi cái bảng PauseMenu (đang nằm ngang hàng ở ngoài MainScene) hiện lên
	$"../../../PauseMenu".toggle_pause()
	
	pass # Replace with function body.
