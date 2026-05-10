# res://scripts/globals/inventory_manager.gd
extends Node

# 1. Tín hiệu phát ra mỗi khi số lượng vật phẩm trong túi đồ thay đổi để cập nhật giao diện
signal inventory_updated

# 2. Khởi tạo túi đồ lưu trữ dưới dạng Dictionary, bao gồm tài nguyên, hạt giống và nông sản
var items: Dictionary = {
	"log": 0, 
	"stone": 0, 
	"corn_seed": 0,   # Hạt giống Ngô (để trồng)
	"tomato_seed": 0, # Hạt giống Cà chua (để trồng)
	"corn": 0,        # Nông sản Ngô (nhặt được, cho gà ăn)
	"tomato": 0,      # Nông sản Cà chua (nhặt được, cho bò ăn)
	"egg": 0, 
	"milk": 0
}

func add_item(item_name: String, amount: int) -> void:
	# 3. Chuẩn hóa tên vật phẩm về chữ thường và cộng thêm số lượng nếu hợp lệ
	var name_key = item_name.to_lower()
	if items.has(name_key):
		items[name_key] += amount
		inventory_updated.emit()
		print("Hệ thống: +", amount, " ", name_key, " vào túi. (Tổng: ", items[name_key], ")")
	else:
		push_error("Lỗi: Vật phẩm '" + name_key + "' chưa được khai báo trong Dictionary!")

func remove_item(item_name: String, amount: int) -> bool:
	# 4. Kiểm tra vật phẩm có tồn tại và kho có đủ số lượng để trừ đi hay không
	var name_key = item_name.to_lower()
	if items.has(name_key) and items[name_key] >= amount:
		items[name_key] -= amount
		inventory_updated.emit()
		print("Hệ thống: -", amount, " ", name_key, " khỏi túi. (Còn: ", items[name_key], ")")
		return true
	return false

func get_item_count(item_name: String) -> int:
	# 5. Truy xuất nhanh số lượng hiện tại của vật phẩm, trả về 0 nếu không tồn tại
	return items.get(item_name.to_lower(), 0)
