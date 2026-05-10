extends Node

# 1. Tín hiệu thông báo vật nuôi đã được cho ăn, dùng để cập nhật hình ảnh máng ăn
signal animal_fed(animal_type: String)

# 2. Hàm giả để tránh lỗi crash khi kịch bản hội thoại (.dialogue) gọi mở khóa công cụ
func unlock_tool(_tool_name: String) -> void:
	print("Hệ thống: Kịch bản gọi mở khóa ", _tool_name, " (Bỏ qua vì đã mở khóa toàn bộ)")

# 3. Hàm cấp vật phẩm trực tiếp cho người chơi, thường được gọi từ các kịch bản
func give_item(item_name: String, amount: int) -> void:
	InventoryManager.add_item(item_name, amount)

# 4. Hàm chuyển đổi giờ hệ thống thành các buổi trong ngày (Sáng, Chiều, Tối)
func get_time_period() -> String:
	var hour = DayAndNightCycleManager.current_hour
	if hour >= 5 and hour < 12: return "Sáng"
	if hour >= 12 and hour < 18: return "Chiều"
	return "Tối"

# 5. Logic xử lý tiêu hao thức ăn (cà chua cho bò, ngô cho gà) khi tương tác với máng ăn
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
# Hàm Mua Hạt Giống: Phân biệt Gỗ và Đá
# =========================================================
func buy_seed(seed_name: String, cost_amount: int) -> void:
	var currency_type = ""
	
	# 6. Xác định loại tiền tệ (tài nguyên) dùng để mua loại hạt giống tương ứng
	if seed_name == "corn_seed":
		currency_type = "log"     # Ngô mua bằng Gỗ
	elif seed_name == "tomato_seed":
		currency_type = "stone"   # Cà chua mua bằng Đá
	else:
		print("Hệ thống: Lỗi! Hạt giống ", seed_name, " chưa được cài đặt giá!")
		return
		
	# 7. Thực hiện giao dịch: Trừ tài nguyên và thêm hạt giống vào kho đồ nếu đủ điều kiện
	if InventoryManager.remove_item(currency_type, cost_amount):
		# Trừ thành công thì bơm Hạt giống vào túi
		InventoryManager.add_item(seed_name, 1)
		print("Hệ thống: Giao dịch thành công! Mất ", cost_amount, " ", currency_type, ", nhận 1 ", seed_name)
	else:
		# 8. Thông báo lỗi phòng hờ nếu người chơi không đủ tài nguyên để mua
		print("Hệ thống: Éo đủ ", currency_type, " mà đòi mua à!")
