class_name NodeDataResource
extends Resource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath
@export var scene_file_path: String 

# [MỚI THÊM CỰC KỲ QUAN TRỌNG] 
# Cái túi (Dictionary) này dùng để chứa dữ liệu riêng của từng loại cây (như tuổi, đã tưới nước chưa...)
@export var custom_data: Dictionary = {} 

func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	# Rút gọn cách lấy đường dẫn .tscn chuẩn của Godot 4
	scene_file_path = node.scene_file_path
	
	# [MỚI THÊM] Bắt cái cây (nếu có hàm get_custom_save_data) nôn dữ liệu tuổi thọ ra để lưu vào túi
	if node.has_method("get_custom_save_data"):
		custom_data = node.get_custom_save_data()
	
	var parent_node = node.get_parent()
	if parent_node != null:
		parent_node_path = parent_node.get_path()
