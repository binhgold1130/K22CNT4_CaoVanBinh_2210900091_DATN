extends Sprite2D

# 1. Khai báo các Component và Scene liên quan
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")

# 2. Khởi tạo thông số cơ bản khi vào game
func _ready() -> void:
	# Cấu hình lượng máu
	damage_component.max_damage = 5
	damage_component.reset_damage()

	# Cấu hình công cụ tương tác (Tạm thời dùng Rìu)
	hurt_component.tool = DataTypes.Tools.AxeWood
	hurt_component.damage_component = damage_component

	# Kết nối các tín hiệu (chịu đòn, chết)
	hurt_component.on_hurt.connect(_on_hurt)
	damage_component.max_damaged_reached.connect(_on_destroy)

# 3. Hàm xử lý khi đối tượng bị đánh trúng
func _on_hurt(hit_damage: int) -> void:
	#print("🪨 Đá bị chém:", hit_damage, " | ", damage_component.current_damage, "/", damage_component.max_damage)
	_play_hit_effect()

# 4. Hàm tạo hiệu ứng hình ảnh (rung/giật) khi bị đánh (Dùng Tween cho mượt)
func _play_hit_effect() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 0.9), 0.05)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05)

# 5. Hàm xử lý khi đối tượng hết máu (bị phá hủy)
func _on_destroy() -> void:
	print("🪨 Đá vỡ rồi!")
	_spawn_stones()
	queue_free()

# 6. Hàm sinh ra vật phẩm rơi xuống đất (Rơi nhiều item)
func _spawn_stones() -> void:
	var drop_count = randi_range(2, 3)
	
	for i in range(drop_count):
		var stone_instance = stone_scene.instantiate() as Node2D
		var offset = Vector2(randf_range(-8, 8), randf_range(-8, 8))
		stone_instance.global_position = global_position + offset
		
		# Đẩy vật phẩm ra ngoài map (Dùng call_deferred để tránh xung đột vật lý)
		get_parent().call_deferred("add_child", stone_instance)
