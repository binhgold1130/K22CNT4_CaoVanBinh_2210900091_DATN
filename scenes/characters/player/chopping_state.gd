class_name ChoppingState
extends NodeState

# 1. Khai báo các thành phần điều khiển nhân vật, hoạt ảnh và vùng va chạm chặt cây
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

var direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	# Khởi tạo trạng thái ban đầu: Tắt vùng va chạm gây sát thương
	hit_component_collision_shape.set_deferred("disabled", true)

func enter() -> void:
	# 2. Xử lý khi bắt đầu vào trạng thái Chặt cây
	direction = player.last_direction # Lấy hướng quay mặt cuối cùng của người chơi
	player.velocity = Vector2.ZERO # Ngắt vận tốc để tránh nhân vật bị trượt khi đang làm việc

	_update_hitbox_position() # Cập nhật vị trí vùng va chạm theo hướng nhìn
	
	# Kích hoạt an toàn vùng va chạm để bắt đầu tương tác với cây
	hit_component_collision_shape.set_deferred("disabled", false)

	_play_chop_animation() # Chạy hoạt ảnh chặt cây tương ứng

func exit() -> void:
	# 3. Tắt vùng va chạm khi rời khỏi trạng thái
	hit_component_collision_shape.set_deferred("disabled", true)

func physics_process(_delta: float) -> void:
	# Đảm bảo nhân vật đứng yên trong suốt quá trình thực hiện hành động
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func check_transition() -> void:
	# 4. Tự động chuyển về trạng thái Nghỉ (Idle) ngay khi kết thúc hoạt ảnh
	if not animated_sprite_2d.is_playing():
		transition.emit("idle")

func _play_chop_animation():
	# 5. Phân loại hướng để chạy đúng hoạt ảnh Chặt cây (Trước, Sau, Trái, Phải)
	if direction.y < 0:
		animated_sprite_2d.play("chopping_back")
	elif direction.y > 0:
		animated_sprite_2d.play("chopping_front")
	elif direction.x > 0:
		animated_sprite_2d.play("chopping_right")
	elif direction.x < 0:
		animated_sprite_2d.play("chopping_left")

func _update_hitbox_position():
	# 6. Điều chỉnh tọa độ Hitbox khớp với vị trí vung rìu theo từng hướng nhìn
	if direction.y < 0:
		hit_component_collision_shape.position = Vector2(0, -14)
	elif direction.y > 0:
		hit_component_collision_shape.position = Vector2(0, 3)
	elif direction.x > 0:
		hit_component_collision_shape.position = Vector2(8, 0)
	elif direction.x < 0:
		hit_component_collision_shape.position = Vector2(-8, -2)
