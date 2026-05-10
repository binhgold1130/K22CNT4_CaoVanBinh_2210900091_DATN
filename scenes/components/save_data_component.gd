class_name SaveDataComponent
extends Node

# 1. Tài nguyên dùng để chứa dữ liệu lưu trữ (Kéo thả file .tres vào Inspector)
@export var save_data_resource: Resource 

const SAVE_PATH = "user://farm_save.tres"

# 2. Hàm thực hiện ghi dữ liệu từ Resource xuống ổ cứng
func save_game_data() -> void:
	# Kiểm tra xác nhận tài nguyên đã được gán trước khi lưu
	if save_data_resource == null:
		print("❌ LỖI: Mày chưa kéo thả Save Data Resource vào Inspector!")
		return
		
	# Tiến hành lưu tài nguyên vào đường dẫn định sẵn
	var error = ResourceSaver.save(save_data_resource, SAVE_PATH)
	
	if error == OK:
		print("💾 Đã lưu toàn bộ Scene vào: ", SAVE_PATH)
	else:
		print("❌ Lỗi lưu Scene: ", error)

# 3. Hàm thực hiện tải dữ liệu từ ổ cứng lên Resource
func load_game_data() -> Resource:
	# Kiểm tra sự tồn tại của file lưu trữ trước khi nạp
	if not ResourceLoader.exists(SAVE_PATH):
		return null
		
	var loaded_resource = ResourceLoader.load(SAVE_PATH)
	if loaded_resource:
		print("📂 Đã tải dữ liệu Scene thành công!")
		return loaded_resource
	return null
