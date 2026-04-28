class_name WateringState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
# 1. Thêm biến export để kéo thả cái Hitbox vào
@export var hit_component_collision_shape: CollisionShape2D 

var direction: Vector2 = Vector2.DOWN

# 2. Thêm hàm _ready để tắt hitbox ngay từ đầu
func _ready() -> void:
	if hit_component_collision_shape:
		hit_component_collision_shape.set_deferred("disabled", true)

func enter() -> void:
	# lấy hướng cuối
	direction = player.last_direction

	# dừng nhân vật
	player.velocity = Vector2.ZERO

	# 3. Cập nhật vị trí vùng tưới và BẬT nó lên
	if hit_component_collision_shape:
		_update_hitbox_position()
		hit_component_collision_shape.set_deferred("disabled", false)

	_play_water_animation()

# 4. Thêm hàm exit để TẮT hitbox khi tưới xong
func exit() -> void:
	if hit_component_collision_shape:
		hit_component_collision_shape.set_deferred("disabled", true)

func physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func check_transition() -> void:
	# animation xong → về idle
	if not animated_sprite_2d.is_playing():
		transition.emit("idle")

# 🎬 animation
func _play_water_animation():
	if direction.y < 0:
		animated_sprite_2d.play("watering_back")
	elif direction.y > 0:
		animated_sprite_2d.play("watering_front")
	elif direction.x > 0:
		animated_sprite_2d.play("watering_right")
	elif direction.x < 0:
		animated_sprite_2d.play("watering_left")

# 5. Thêm hàm chỉnh tọa độ (Copy form của ChoppingState sang)
func _update_hitbox_position():
	# Mày có thể tinh chỉnh lại các con số tọa độ này sao cho cái vùng tưới nước
	# nằm trúng ngay chỗ vòi nước của sprite đổ xuống nhé.
	if direction.y < 0:
		hit_component_collision_shape.position = Vector2(0, -14)
	elif direction.y > 0:
		hit_component_collision_shape.position = Vector2(0, 3)
	elif direction.x > 0:
		hit_component_collision_shape.position = Vector2(8, 0)
	elif direction.x < 0:
		hit_component_collision_shape.position = Vector2(-8, -2)
