extends Node

# [MỚI] Tín hiệu phát ra để cái máng ăn ở chuồng (Sprite) biết mà đổi hình thành máng đầy
signal animal_fed(animal_type: String)

# Thêm hàm này để kịch bản (.dialogue) của Trưởng Làng không bị crash khi gọi
func unlock_tool(_tool_name: String) -> void:
	print("Hệ thống: Kịch bản gọi mở khóa ", _tool_name, " (Bỏ qua vì đã mở khóa toàn bộ)")

# Hàm tặng đồ (Gọi từ kịch bản nếu cần)
func give_item(item_name: String, amount: int) -> void:
	InventoryManager.add_item(item_name, amount)

# Hàm lấy thời gian
func get_time_period() -> String:
	var hour = DayAndNightCycleManager.current_hour
	if hour >= 5 and hour < 12: return "Sáng"
	if hour >= 12 and hour < 18: return "Chiều"
	return "Tối"

# Hàm xử lý cho ăn gọi từ kịch bản máng ăn của Bò/Gà (.dialogue)
func feed_animals(animal_type: String) -> void:
	if animal_type == "cow":
		if InventoryManager.remove_item("tomato", 1):
			print("Hệ thống: Đã trừ 1 Cà chua. Bò đang ăn!")
			animal_fed.emit("cow")
		else:
			print("Hệ thống: Không đủ Cà chua trong túi!")
			
	elif animal_type == "chicken":
		if InventoryManager.remove_item("corn", 1):
			print("Hệ thống: Đã trừ 1 Ngô. Gà đang ăn!")
			animal_fed.emit("chicken")
		else:
			print("Hệ thống: Không đủ Ngô trong túi!")

# =========================================================
# [ĐÃ SỬA] Hàm Mua Hạt Giống: Phân biệt Gỗ và Đá
# =========================================================
func buy_seed(seed_name: String, cost_amount: int) -> void:
	var currency_type = ""
	
	# Xác định xem hạt giống này phải mua bằng cái gì
	if seed_name == "corn_seed":
		currency_type = "log"     # Ngô mua bằng Gỗ
	elif seed_name == "tomato_seed":
		currency_type = "stone"   # Cà chua mua bằng Đá
	else:
		print("Hệ thống: Lỗi! Hạt giống ", seed_name, " chưa được cài đặt giá!")
		return
		
	# Bắt đầu trừ tiền (Gỗ hoặc Đá)
	if InventoryManager.remove_item(currency_type, cost_amount):
		# Trừ thành công thì bơm Hạt giống vào túi
		InventoryManager.add_item(seed_name, 1)
		print("Hệ thống: Giao dịch thành công! Mất ", cost_amount, " ", currency_type, ", nhận 1 ", seed_name)
	else:
		# Đề phòng lỗi (Dù thằng file .dialogue đã check rồi)
		print("Hệ thống: Éo đủ ", currency_type, " mà đòi mua à!")
