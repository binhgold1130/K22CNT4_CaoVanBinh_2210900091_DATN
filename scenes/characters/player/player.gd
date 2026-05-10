class_name Player
extends CharacterBody2D

# 1. Tín hiệu phát ra khi công cụ đang sử dụng thay đổi
signal tool_changed(tool: DataTypes.Tools)

# 2. Khai báo các thông số vật lý cho di chuyển và công cụ hiện tại
@export var speed: float = 80.0
@export var acceleration: float = 900.0
@export var friction: float = 1100.0
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN

# 3. Danh sách các công cụ có sẵn trong hệ thống
var tools_list = [
	DataTypes.Tools.None,
	DataTypes.Tools.AxeWood,
	DataTypes.Tools.TillGround,
	DataTypes.Tools.WaterCrops,
	DataTypes.Tools.PlantCorn,
	DataTypes.Tools.PlantTomato
]

func _ready() -> void:
	# Kết nối với trình quản lý công cụ và khởi tạo nhạc nền
	ToolManager.tool_selected.connect(_on_tool_selected_from_manager)
	AudioManager.play_bgm("bgm_farm_day.mp3")

func _physics_process(delta: float) -> void:
	# 4. Xử lý logic di chuyển mượt mà với gia tốc và ma sát
	var target_velocity = player_direction * speed
	if player_direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func set_direction(direction: Vector2):
	# Cập nhật hướng di chuyển hiện tại và hướng nhìn cuối cùng
	player_direction = direction
	if direction != Vector2.ZERO:
		last_direction = direction

func _unhandled_input(event: InputEvent) -> void:
	# 5. Tiếp nhận đầu vào từ bàn phím để chuyển đổi nhanh hoặc cuộn công cụ
	if event.is_action_pressed("tool_1"): _toggle_tool(tools_list[1])
	elif event.is_action_pressed("tool_2"): _toggle_tool(tools_list[2])
	elif event.is_action_pressed("tool_3"): _toggle_tool(tools_list[3])
	elif event.is_action_pressed("tool_4"): _toggle_tool(tools_list[4])
	elif event.is_action_pressed("tool_5"): _toggle_tool(tools_list[5])
	
	if event.is_action_pressed("next_tool"): _scroll_tool(1)
	elif event.is_action_pressed("prev_tool"): _scroll_tool(-1)

func _toggle_tool(tool: DataTypes.Tools) -> void:
	# Bật/Tắt công cụ: Nếu chọn lại công cụ cũ thì sẽ đưa về trạng thái không cầm gì (None)
	if ToolManager.selected_tool == tool:
		ToolManager.select_tool(DataTypes.Tools.None)
	else:
		ToolManager.select_tool(tool)

func _scroll_tool(scroll_dir: int) -> void:
	# 6. Xử lý vòng lặp danh sách công cụ khi người chơi cuộn chuột hoặc bấm phím chuyển tiếp
	var current_index = tools_list.find(ToolManager.selected_tool)
	if current_index == -1: current_index = 0
	
	var new_index = (current_index + scroll_dir) % tools_list.size()
	if new_index < 0:
		new_index = tools_list.size() - 1
		
	ToolManager.select_tool(tools_list[new_index])

func _on_tool_selected_from_manager(tool: DataTypes.Tools):
	# Đồng bộ hóa công cụ hiện tại từ trình quản lý và phát tín hiệu thay đổi
	current_tool = tool
	tool_changed.emit(tool)
