class_name ChickenWalkState
extends NodeState

# 1. Khai báo các thành phần điều khiển vật lý và hoạt ảnh của gà
@export var chicken: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: float = 25.0 
@export var wander_radius: float = 100.0 # Khoảng cách tối đa gà được phép đi xa khỏi vị trí gốc

var walk_timer: float = 0.0
var move_direction: Vector2 = Vector2.ZERO
var home_position: Vector2 # Vị trí trung tâm (tổ) của con gà

func _ready() -> void:
	# 2. Khởi tạo vị trí gốc (home_position) sau khi các thành phần đã sẵn sàng
	await get_tree().process_frame
	if chicken:
		home_position = chicken.global_position

func enter() -> void:
	# 3. Thiết lập hướng đi và thời gian di chuyển ngẫu nhiên
	_calculate_wander_direction()
	
	walk_timer = randf_range(1.5, 4.0)
	
	if animated_sprite_2d:
		animated_sprite_2d.play("walk") # Chạy hoạt ảnh đi bộ
		if move_direction.x != 0:
			animated_sprite_2d.flip_h = move_direction.x < 0 # Lật hình ảnh theo hướng di chuyển

func _calculate_wander_direction() -> void:
	# 4. Kiểm tra khoảng cách để giữ gà không đi quá giới hạn (wander_radius)
	var distance_from_home = chicken.global_position.distance_to(home_position)
	
	if distance_from_home > wander_radius:
		# Ép hướng di chuyển quay trở lại vị trí gốc
		move_direction = (home_position - chicken.global_position).normalized()
	else:
		# Chọn hướng di chuyển ngẫu nhiên hoàn toàn
		var random_x = randf_range(-1, 1)
		var random_y = randf_range(-1, 1)
		move_direction = Vector2(random_x, random_y).normalized()

func physics_process(delta: float) -> void:
	# 5. Xử lý di chuyển vật lý và kiểm tra va chạm
	if walk_timer > 0:
		walk_timer -= delta
		chicken.velocity = move_direction * speed
		
		var collided = chicken.move_and_slide()
		
		# Dừng di chuyển ngay lập tức nếu va chạm với vật cản
		if collided and chicken.get_slide_collision_count() > 0:
			walk_timer = 0 
	else:
		chicken.velocity = Vector2.ZERO

func check_transition() -> void:
	# 6. Chuyển về trạng thái Đứng im (Idle) khi hết thời gian di chuyển
	if walk_timer <= 0:
		transition.emit("idle")
