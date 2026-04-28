extends Sprite2D

# 1. Khai báo các Component và Scene liên quan
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
var log_scene = preload("res://scenes/objects/trees/log.tscn")

# 2. Khởi tạo thông số cơ bản khi vào game
func _ready() -> void:
	# Cấu hình lượng máu
	damage_component.max_damage = 3
	damage_component.reset_damage()

	# Cấu hình công cụ tương tác (Rìu)
	hurt_component.tool = DataTypes.Tools.AxeWood
	hurt_component.damage_component = damage_component

	# Kết nối các tín hiệu (chịu đòn, chết)
	hurt_component.on_hurt.connect(_on_hurt)
	damage_component.max_damaged_reached.connect(_on_destroy)

# 3. Hàm xử lý khi đối tượng bị đánh trúng
func _on_hurt(hit_damage: int) -> void:
	#print("🌲 cây bị chặt:", hit_damage)
	_play_hit_effect()

# 4. Hàm tạo hiệu ứng hình ảnh (rung/giật) khi bị đánh
func _play_hit_effect() -> void:
	scale = Vector2(1.1, 0.9)
	await get_tree().create_timer(0.08).timeout
	scale = Vector2.ONE

# 5. Hàm xử lý khi đối tượng hết máu (bị phá hủy)
func _on_destroy() -> void:
	print("🌲 cây đổ!")
	_spawn_log()
	queue_free()

# 6. Hàm sinh ra vật phẩm rơi xuống đất
func _spawn_log() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
	log_instance.global_position = global_position + offset
	
	# Đẩy vật phẩm ra ngoài map (Dùng call_deferred để tránh xung đột vật lý)
	get_parent().call_deferred("add_child", log_instance)
