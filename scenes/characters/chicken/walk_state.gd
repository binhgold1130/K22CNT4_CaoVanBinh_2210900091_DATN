class_name ChickenWalkState
extends NodeState

@export var chicken: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: float = 25.0 
@export var wander_radius: float = 100.0 # Khoảng cách tối đa gà được đi xa khỏi vị trí gốc

var walk_timer: float = 0.0
var move_direction: Vector2 = Vector2.ZERO
var home_position: Vector2 # Vị trí "tổ" của con gà

func _ready() -> void:
	# Lưu vị trí ban đầu ngay khi game bắt đầu
	# Lưu ý: Chờ một chút để chicken được gán từ Inspector
	await  get_tree().process_frame
	if chicken:
		home_position = chicken.global_position

func enter() -> void:
	_calculate_wander_direction()
	
	walk_timer = randf_range(1.5, 4.0)
	
	if animated_sprite_2d:
		animated_sprite_2d.play("walk")
		if move_direction.x != 0:
			animated_sprite_2d.flip_h = move_direction.x < 0

func _calculate_wander_direction() -> void:
	# Tính khoảng cách hiện tại so với "tổ"
	var distance_from_home = chicken.global_position.distance_to(home_position)
	
	if distance_from_home > wander_radius:
		# NẾU QUÁ XA: Ép hướng đi quay về phía home_position
		move_direction = (home_position - chicken.global_position).normalized()
	else:
		# NẾU CÒN TRONG TẦM: Chọn hướng ngẫu nhiên như cũ
		var random_x = randf_range(-1, 1)
		var random_y = randf_range(-1, 1)
		move_direction = Vector2(random_x, random_y).normalized()

func physics_process(delta: float) -> void:
	if walk_timer > 0:
		walk_timer -= delta
		chicken.velocity = move_direction * speed
		
		# move_and_slide() trả về true nếu có va chạm xảy ra
		var collided = chicken.move_and_slide()
		
		# Nếu đâm vào tường hoặc con gà khác, dừng lại và nghỉ luôn để tìm hướng mới
		if collided and chicken.get_slide_collision_count() > 0:
			walk_timer = 0 # Ép kết thúc trạng thái Walk
	else:
		chicken.velocity = Vector2.ZERO

func check_transition() -> void:
	if walk_timer <= 0:
		transition.emit("idle")
