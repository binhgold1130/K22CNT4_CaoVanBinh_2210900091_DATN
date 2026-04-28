class_name CowWalkState
extends NodeState

@export var cow: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: float = 15.0 # Bò đi rất chậm, khoảng 15-20 là vừa
@export var wander_radius: float = 150.0 # Bò to nên vùng đi dạo rộng hơn gà

var walk_timer: float = 0.0
var move_direction: Vector2 = Vector2.ZERO
var home_position: Vector2

func _ready() -> void:
	# Chờ 1 frame để đảm bảo node đã vào scene tree và có tọa độ đúng
	await get_tree().process_frame
	if cow:
		home_position = cow.global_position

func enter() -> void:
	_calculate_wander_direction()
	
	# Bò đi chậm nhưng mỗi lần đi thường đi lâu hơn gà một chút
	walk_timer = randf_range(2.0, 5.0)
	
	if animated_sprite_2d:
		animated_sprite_2d.play("walk") # Đảm bảo m có animation tên "walk" cho bò
		if move_direction.x != 0:
			animated_sprite_2d.flip_h = move_direction.x < 0

func _calculate_wander_direction() -> void:
	var distance_from_home = cow.global_position.distance_to(home_position)
	
	# Nếu bò đi quá xa khu vực được phép, ép nó quay đầu về gốc
	if distance_from_home > wander_radius:
		move_direction = (home_position - cow.global_position).normalized()
	else:
		# Chọn hướng ngẫu nhiên
		var random_x = randf_range(-1, 1)
		var random_y = randf_range(-1, 1)
		move_direction = Vector2(random_x, random_y).normalized()

func physics_process(delta: float) -> void:
	if walk_timer > 0:
		walk_timer -= delta
		cow.velocity = move_direction * speed
		
		# Xử lý va chạm: nếu đâm vào tường hoặc bò khác thì dừng lại nghỉ luôn
		var collided = cow.move_and_slide()
		if collided and cow.get_slide_collision_count() > 0:
			walk_timer = 0
	else:
		cow.velocity = Vector2.ZERO

func check_transition() -> void:
	# Hết giờ đi thì chuyển về trạng thái nghỉ (idle)
	if walk_timer <= 0:
		transition.emit("idle")
