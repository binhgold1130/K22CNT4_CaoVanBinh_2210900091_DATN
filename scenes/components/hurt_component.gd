class_name HurtComponent
extends Area2D

# 1. Khai báo thông số cơ bản
@export var tool: DataTypes.Tools = DataTypes.Tools.None # Loại dụng cụ yêu cầu để tương tác (VD: Rìu, Bình tưới)
@export var damage_component: DamageComponent            # Nơi lưu trữ máu (Cây/đá có máu, Nông sản thì để trống)

# Tín hiệu báo ra ngoài khi bị tác động thành công (dùng để rớt đồ, bắn hạt nước...)
signal on_hurt(damage: int)

# 2. Khởi tạo khi vào game
func _ready() -> void:
	# Kết nối tín hiệu va chạm an toàn (tránh lỗi kết nối đúp nếu node bị reload)
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

# 3. Xử lý logic khi có vật thể chạm vào vùng này
func _on_area_entered(area: Area2D) -> void:
	
	# Bước 3.1: Kiểm tra xem vật chạm vào có phải là công cụ đánh (HitComponent) không
	var hit_component := area as HitComponent
	if hit_component == null:
		return # Không phải công cụ thì bỏ qua
	
	# Bước 3.2: Kiểm tra công cụ có khớp với yêu cầu của vật thể không
	if hit_component.current_tool != tool:
		return # Sai công cụ (VD: Dùng rìu chém cây ngô) thì chặn lại ngay
	
	# Bước 3.3: Xử lý trừ máu (Chỉ áp dụng cho vật thể có máu như Cây, Đá)
	# Nếu vật thể (như Cây Ngô) không có máu thì bỏ qua bước này, chạy tiếp xuống dưới
	if damage_component != null:
		damage_component.apply_damage(hit_component.hit_damage)
	
	# Bước 3.4: Chốt hạ - Phát tín hiệu báo đã tương tác thành công
	# Truyền kèm lượng sát thương/tác động ra ngoài để xử lý hiệu ứng
	on_hurt.emit(hit_component.hit_damage)
