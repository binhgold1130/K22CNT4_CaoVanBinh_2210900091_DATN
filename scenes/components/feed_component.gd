# res://scenes/components/feed_component.gd
extends Area2D

# 1. Khai báo tín hiệu khi thêm thức ăn và loại động vật tương ứng
signal food_added(type: String)
@export var animal_type: String = ""

# 2. Hàm xử lý logic cho việc cho động vật ăn dựa trên công cụ đang chọn
func try_to_feed() -> bool:
	var selected = ToolManager.selected_tool 
	var item_name = ""
	
	# 3. Phân loại vật phẩm tiêu thụ dựa trên loại hạt giống/công cụ người chơi cầm
	if selected == DataTypes.Tools.PlantCorn: item_name = "corn"
	elif selected == DataTypes.Tools.PlantTomato: item_name = "tomato"
		
	# Nếu không cầm vật phẩm phù hợp thì thoát
	if item_name == "": return false

	# 4. Kiểm tra và trừ số lượng vật phẩm trong kho đồ (InventoryManager)
	if InventoryManager.remove_item(item_name, 1): 
		# Phát tín hiệu báo cho hệ thống quản lý hội thoại và trạng thái ăn của động vật
		GameDialogueManager.animal_fed.emit(animal_type)
		food_added.emit(item_name)
		return true
	else:
		# Thông báo lỗi ra cửa sổ Output nếu không đủ số lượng vật phẩm
		print("Hệ thống: Hết ", item_name, " rồi!")
		return false
