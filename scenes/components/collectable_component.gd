class_name CollectableComponent
extends Area2D

@export var collectable_name: String
@export var amount: int = 1

func _ready() -> void:
	# Kết nối signal va chạm của chính Area2D
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra xem có phải Player nhặt không
	if not body is Player:
		return

	# 1. Gọi Manager để cộng dồn dữ liệu
	InventoryManager.add_item(collectable_name, amount)
	
	# 2. Vô hiệu hóa va chạm ngay lập tức để tránh nhặt 2 lần trong 1 frame
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
	# 3. Xóa vật thể khỏi bản đồ một cách an toàn
	call_deferred("remove_item")

func remove_item() -> void:
	# Xóa Node cha (Node chứa hình ảnh vật phẩm)
	if get_parent():
		get_parent().queue_free()
