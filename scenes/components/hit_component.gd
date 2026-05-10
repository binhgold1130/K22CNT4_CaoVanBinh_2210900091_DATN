class_name HitComponent
extends Area2D

# 1. Khai báo liên kết với nhân vật chính, công cụ hiện tại và lượng sát thương gây ra
@export var player: Player
var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage: int = 1


func _ready() -> void:
	# 2. Tự động tìm kiếm Node Player nếu chưa được gán trong Inspector
	if player == null:
		player = get_parent() as Player

	# 3. Kết nối tín hiệu thay đổi công cụ từ nhân vật để cập nhật trạng thái
	if player != null:
		current_tool = player.current_tool
		player.tool_changed.connect(_on_player_tool_changed)


func _process(_delta: float) -> void:
	# 4. Cập nhật liên tục loại công cụ mà người chơi đang cầm
	if player != null:
		current_tool = player.current_tool


func _on_player_tool_changed(tool: DataTypes.Tools) -> void:
	# 5. Xử lý đồng bộ dữ liệu khi nhận tín hiệu thay đổi công cụ
	current_tool = tool
