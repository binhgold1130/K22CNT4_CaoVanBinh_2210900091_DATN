extends PanelContainer

# Sử dụng @onready để gán các Label đúng theo cấu trúc m thiết kế
@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var corn_label: Label = $MarginContainer/VBoxContainer/CornLabel/CornLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/EggLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/MilkLabel

func _ready() -> void:
	# Lắng nghe signal từ Manager: Có đồ mới là cập nhật UI ngay
	InventoryManager.inventory_updated.connect(update_ui)
	# Cập nhật lần đầu để hiển thị số 0 khi vào game
	update_ui()

func update_ui() -> void:
	# Gán giá trị từ Dictionary vào các nhãn dán trên màn hình
	log_label.text = str(InventoryManager.items["log"])
	stone_label.text = str(InventoryManager.items["stone"])
	corn_label.text = str(InventoryManager.items["corn"])
	tomato_label.text = str(InventoryManager.items["tomato"])
	egg_label.text = str(InventoryManager.items["egg"])
	milk_label.text = str(InventoryManager.items["milk"])
