class_name Player
extends CharacterBody2D

signal tool_changed(tool: DataTypes.Tools)

@export var speed: float = 80.0
@export var acceleration: float = 900.0
@export var friction: float = 1100.0
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN

var tools_list = [
	DataTypes.Tools.None,
	DataTypes.Tools.AxeWood,
	DataTypes.Tools.TillGround,
	DataTypes.Tools.WaterCrops,
	DataTypes.Tools.PlantCorn,
	DataTypes.Tools.PlantTomato
]

func _ready() -> void:
	ToolManager.tool_selected.connect(_on_tool_selected_from_manager)
	# GỌI TỔNG ĐÀI: Bật nhạc nền chill chill ngay khi nhân vật xuất hiện!
	AudioManager.play_bgm("bgm_farm_day.mp3")

func _physics_process(delta: float) -> void:
	var target_velocity = player_direction * speed
	if player_direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func set_direction(direction: Vector2):
	player_direction = direction
	if direction != Vector2.ZERO:
		last_direction = direction

func _unhandled_input(event: InputEvent) -> void:
	# Thả tự do: Bấm là đổi, không kiểm tra khóa đồ nữa!
	if event.is_action_pressed("tool_1"): _toggle_tool(tools_list[1])
	elif event.is_action_pressed("tool_2"): _toggle_tool(tools_list[2])
	elif event.is_action_pressed("tool_3"): _toggle_tool(tools_list[3])
	elif event.is_action_pressed("tool_4"): _toggle_tool(tools_list[4])
	elif event.is_action_pressed("tool_5"): _toggle_tool(tools_list[5])
	
	if event.is_action_pressed("next_tool"): _scroll_tool(1)
	elif event.is_action_pressed("prev_tool"): _scroll_tool(-1)

func _toggle_tool(tool: DataTypes.Tools) -> void:
	if ToolManager.selected_tool == tool:
		ToolManager.select_tool(DataTypes.Tools.None)
	else:
		ToolManager.select_tool(tool)

func _scroll_tool(scroll_dir: int) -> void:
	var current_index = tools_list.find(ToolManager.selected_tool)
	if current_index == -1: current_index = 0
	
	var new_index = (current_index + scroll_dir) % tools_list.size()
	if new_index < 0:
		new_index = tools_list.size() - 1
		
	ToolManager.select_tool(tools_list[new_index])

func _on_tool_selected_from_manager(tool: DataTypes.Tools):
	current_tool = tool
	tool_changed.emit(tool)
