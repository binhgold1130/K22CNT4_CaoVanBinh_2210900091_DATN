class_name SaveDataComponent
extends Node

# MỚI THÊM: Dòng này sẽ biến thành cái ô trống ở Inspector để mày kéo thả file .tres vào
@export var save_data_resource: Resource 

const SAVE_PATH = "user://farm_save.tres"

# Vì đã có biến ở trên, nên hàm này KHÔNG CẦN truyền dữ liệu vào trong ngoặc tròn nữa
func save_game_data() -> void:
	# Kiểm tra đề phòng mày quên kéo thả file vào Inspector
	if save_data_resource == null:
		print("❌ LỖI: Mày chưa kéo thả Save Data Resource vào Inspector!")
		return
		
	var error = ResourceSaver.save(save_data_resource, SAVE_PATH)
	
	if error == OK:
		print("💾 Đã lưu toàn bộ Scene vào: ", SAVE_PATH)
	else:
		print("❌ Lỗi lưu Scene: ", error)

func load_game_data() -> Resource:
	if not ResourceLoader.exists(SAVE_PATH):
		return null
		
	var loaded_resource = ResourceLoader.load(SAVE_PATH)
	if loaded_resource:
		print("📂 Đã tải dữ liệu Scene thành công!")
		return loaded_resource
	return null
