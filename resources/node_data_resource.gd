class_name NodeDataResource
extends Resource

# 1. Vị trí và đường dẫn của đối tượng trên cây thư mục Scene
@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath
@export var scene_file_path: String 

# 2. Túi chứa dữ liệu riêng (như tuổi cây, trạng thái tưới nước...)
@export var custom_data: Dictionary = {} 

# Hàm thực hiện ghi nhận dữ liệu từ Node vào Resource
func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	# Lấy đường dẫn file .tscn của đối tượng
	scene_file_path = node.scene_file_path
	
	# Thu thập dữ liệu đặc thù từ hàm tùy chỉnh của đối tượng (nếu có)
	if node.has_method("get_custom_save_data"):
		custom_data = node.get_custom_save_data()
	
	# Xác định và lưu đường dẫn của Node cha
	var parent_node = node.get_parent()
	if parent_node != null:
		parent_node_path = parent_node.get_path()
