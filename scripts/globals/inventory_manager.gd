# res://scripts/globals/inventory_manager.gd
extends Node

signal inventory_updated

# Khởi tạo túi đồ 
var items: Dictionary = {
	"log": 0, 
	"stone": 0, 
	"corn_seed": 0,   # [MỚI] Hạt giống Ngô (để trồng)
	"tomato_seed": 0, # [MỚI] Hạt giống Cà chua (để trồng)
	"corn": 0,        # Nông sản Ngô (nhặt được, cho gà ăn)
	"tomato": 0,      # Nông sản Cà chua (nhặt được, cho bò ăn)
	"egg": 0, 
	"milk": 0
}

func add_item(item_name: String, amount: int) -> void:
	var name_key = item_name.to_lower()
	if items.has(name_key):
		items[name_key] += amount
		inventory_updated.emit()
		print("Hệ thống: +", amount, " ", name_key, " vào túi. (Tổng: ", items[name_key], ")")
	else:
		push_error("Lỗi: Vật phẩm '" + name_key + "' chưa được khai báo trong Dictionary!")

func remove_item(item_name: String, amount: int) -> bool:
	var name_key = item_name.to_lower()
	if items.has(name_key) and items[name_key] >= amount:
		items[name_key] -= amount
		inventory_updated.emit()
		print("Hệ thống: -", amount, " ", name_key, " khỏi túi. (Còn: ", items[name_key], ")")
		return true
	return false

func get_item_count(item_name: String) -> int:
	return items.get(item_name.to_lower(), 0)
