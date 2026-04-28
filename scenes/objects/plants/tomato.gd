extends Node2D

# 1. Khai báo các thành phần (Nodes) cấu tạo nên cây
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var interactable_component: InteractableComponent = $InteractableComponent

# Biến lưu trữ trạng thái sinh trưởng hiện tại
var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

# 2. Thiết lập ban đầu khi cây xuất hiện
func _ready() -> void:
	# Tắt hiệu ứng hạt ban đầu
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	# Kết nối tín hiệu tưới nước
	hurt_component.on_hurt.connect(on_hurt)
	
	# Kết nối tín hiệu tương tác phím E
	if interactable_component:
		interactable_component.interacted.connect(_on_player_interact)

# 3. Cập nhật hình ảnh theo giai đoạn phát triển (Hàng Cà chua nằm dưới hàng Ngô)
func _process(_delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	
	# Mapping số Frame cho cà chua (Cộng thêm 6 frame so với ngô)
	match growth_state:
		DataTypes.GrowthStates.Seed: sprite_2d.frame = 7         # Ụ đất
		DataTypes.GrowthStates.Germination: sprite_2d.frame = 8  # Mầm cà chua
		DataTypes.GrowthStates.Vegetative: sprite_2d.frame = 9   # Cây vừa
		DataTypes.GrowthStates.Reproduction: sprite_2d.frame = 9 # Cây vừa
		DataTypes.GrowthStates.Maturity: sprite_2d.frame = 10    # Cây có quả xanh/đỏ
		DataTypes.GrowthStates.Harvesting: sprite_2d.frame = 11  # Quả cà chua chín rụng

	# Bật hiệu ứng lấp lánh khi chín
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
	else:
		flowering_particles.emitting = false

# 4. Logic xử lý khi tưới nước (nhận tín hiệu từ HurtComponent)
func on_hurt(_hit_damage: int) -> void:
	# Nếu cây chưa được tưới
	if !growth_cycle_component.is_watered:
		
		growth_cycle_component.is_watered = true
		# Bật hiệu ứng nước 5 giây 
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false


# 5. Logic thu hoạch cà chua bằng phím E
func _on_player_interact() -> void:
	# Kiểm tra trạng thái chín để cho phép nhặt
	if growth_state == DataTypes.GrowthStates.Harvesting:
		# Thêm cà chua vào kho đồ
		InventoryManager.add_item("tomato", 1)
		
		# Xóa đối tượng cây sau khi nhặt
		queue_free()

func get_custom_save_data() -> Dictionary:
	return {
		"days_grown": growth_cycle_component.days_grown,
		"is_watered": growth_cycle_component.is_watered
	}

func apply_custom_load_data(data: Dictionary) -> void:
	if data.has("days_grown"):
		growth_cycle_component.days_grown = data["days_grown"]
		growth_cycle_component.is_watered = data.get("is_watered", false)
		growth_cycle_component.growth_states()
		growth_cycle_component.harvest_state()
