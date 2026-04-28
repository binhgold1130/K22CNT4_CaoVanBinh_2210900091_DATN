extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $DetectionArea 

var is_open := false

func _ready() -> void:
	# Kết nối signal tự động mở khi có body đi vào vùng dò tìm
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	
	collision_layer = 1

# Khi có vật thể đi vào vùng dò tìm
func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra xem vật thể đó có phải là Player không
	if body is Player:
		open_door()

# Khi vật thể rời khỏi vùng dò tìm
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		close_door()

# Hàm mở cửa
func open_door() -> void:
	if is_open:
		return 

	is_open = true
	animated_sprite_2d.play("open_door")
	# Đổi layer sang 2 để Player có thể đi xuyên qua mà không bị cản
	collision_layer = 2 
	print("Hệ thống: Cửa đã mở tự động!")

# Hàm đóng cửa
func close_door() -> void:
	if not is_open:
		return 

	is_open = false
	animated_sprite_2d.play("close_door")
	# Đổi layer về 1 để biến lại thành bức tường
	collision_layer = 1
	print("Hệ thống: Cửa đã đóng!")
