extends Node2D

# Tùy chỉnh tốc độ và hướng trôi của Camera
@export var camera_speed: float = 15.0 
@export var pan_direction: Vector2 = Vector2(1, -0.2) # Trôi hơi chéo lên trên

# Chỉ đường cho code tìm thấy thằng Player
@onready var player: Node2D = $Characters/Player

var menu_camera: Camera2D

func _ready() -> void:
	# 1. Trói Player lại không cho nhận nút bấm ở ngoài Menu
	if player:
		player.set_physics_process(false)
		player.set_process_unhandled_input(false)
		
		# Tắt Camera mặc định của Player đi
		var p_cam = player.get_node_or_null("Camera2D")
		if p_cam:
			p_cam.enabled = false
			
	# 2. Sinh ra một cái Camera riêng chuyên để quay phim ở Menu
	menu_camera = Camera2D.new()
	
	# Phải add Camera vào Map TRƯỚC!
	add_child(menu_camera) 
	
	# Sau khi add vào rồi mới được phép bật nó lên
	menu_camera.make_current() 
	
	# Đặt Camera nằm ngay vị trí thằng Player
	if player:
		menu_camera.global_position = player.global_position

func _process(delta: float) -> void:
	# 3. Cho Camera trôi chầm chậm tạo cảm giác chill chill
	if menu_camera:
		menu_camera.global_position += pan_direction * camera_speed * delta
