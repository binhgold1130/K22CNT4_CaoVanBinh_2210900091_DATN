class_name WateringState
extends NodeState

# 1. Khai báo thành phần điều khiển nhân vật, hoạt ảnh và vùng va chạm tưới nước
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D 

var direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	# 2. Đảm bảo vùng va chạm tưới nước được tắt khi bắt đầu
	if hit_component_collision_shape:
		hit_component_collision_shape.set_deferred("disabled", true)

func enter() -> void:
	# 3. Xử lý khi bắt đầu vào trạng thái Tưới nước
	direction = player.last_direction
	player.velocity = Vector2.ZERO

	# Cập nhật vị trí và kích hoạt vùng va chạm để thực hiện tưới
	if hit_component_collision_shape:
		_update_hitbox_position()
		hit_component_collision_shape.set_deferred("disabled", false)

	_play_water_animation()

func exit() -> void:
	# 4. Ngắt kích hoạt vùng va chạm ngay khi rời khỏi trạng thái
	if hit_component_collision_shape:
		hit_component_collision_shape.set_deferred("disabled", true)

func physics_process(_delta: float) -> void:
	# Giữ nhân vật đứng yên trong quá trình tưới
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func check_transition() -> void:
	# 5. Tự động chuyển về trạng thái Nghỉ (Idle) khi hoạt ảnh kết thúc
	if not animated_sprite_2d.is_playing():
		transition.emit("idle")

func _play_water_animation():
	# 6. Kích hoạt hoạt ảnh tưới nước tương ứng với hướng nhìn của nhân vật
	if direction.y < 0:
		animated_sprite_2d.play("watering_back")
	elif direction.y > 0:
		animated_sprite_2d.play("watering_front")
	elif direction.x > 0:
		animated_sprite_2d.play("watering_right")
	elif direction.x < 0:
		animated_sprite_2d.play("watering_left")

func _update_hitbox_position():
	# 7. Điều chỉnh tọa độ vùng va chạm khớp với vị trí vòi nước theo từng hướng
	if direction.y < 0:
		hit_component_collision_shape.position = Vector2(0, -14)
	elif direction.y > 0:
		hit_component_collision_shape.position = Vector2(0, 3)
	elif direction.x > 0:
		hit_component_collision_shape.position = Vector2(8, 0)
	elif direction.x < 0:
		hit_component_collision_shape.position = Vector2(-8, -2)
