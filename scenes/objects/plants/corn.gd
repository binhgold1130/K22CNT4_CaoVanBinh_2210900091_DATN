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
	# Tắt các hiệu ứng hạt (particles) khi mới vào game
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	# Kết nối tín hiệu khi bị tác động (tưới nước)
	hurt_component.on_hurt.connect(on_hurt)
	
	# Kết nối tín hiệu khi người chơi đứng gần và bấm phím E (thu hoạch)
	if interactable_component:
		interactable_component.interacted.connect(_on_player_interact)

# 3. Cập nhật hình ảnh theo từng giai đoạn phát triển (Chạy liên tục)
func _process(_delta: float) -> void:
	# Lấy trạng thái sinh trưởng từ bộ đếm GrowthCycleComponent
	growth_state = growth_cycle_component.get_current_growth_state()
	
	# Mapping (khớp) trạng thái với số Frame tương ứng trên Sprite Sheet
	match growth_state:
		DataTypes.GrowthStates.Seed: sprite_2d.frame = 1         # Ụ đất
		DataTypes.GrowthStates.Germination: sprite_2d.frame = 2  # Mầm non
		DataTypes.GrowthStates.Vegetative: sprite_2d.frame = 3   # Cây vừa
		DataTypes.GrowthStates.Reproduction: sprite_2d.frame = 3 # Cây vừa (dùng chung ảnh)
		DataTypes.GrowthStates.Maturity: sprite_2d.frame = 4     # Cây có bắp
		DataTypes.GrowthStates.Harvesting: sprite_2d.frame = 5   # Trái bắp đã chín hẳn

	# Hiệu ứng hạt lấp lánh khi cây ở giai đoạn trưởng thành (Maturity)
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

# 5. Logic xử lý thu hoạch khi người chơi bấm phím E
func _on_player_interact() -> void:
	# Chỉ cho phép thu hoạch khi cây đã chín (Harvesting)
	if growth_state == DataTypes.GrowthStates.Harvesting:
		# Thêm 1 bắp ngô vào kho đồ thông qua InventoryManager
		InventoryManager.add_item("corn", 1)
		
		# Xóa cây khỏi map sau khi thu hoạch thành công
		queue_free()

# Trả về tuổi của cây cho hệ thống Save
func get_custom_save_data() -> Dictionary:
	return {
		"days_grown": growth_cycle_component.days_grown,
		"is_watered": growth_cycle_component.is_watered
	}

# Nhận lại tuổi từ hệ thống Load và ép cây lớn ngay lập tức
func apply_custom_load_data(data: Dictionary) -> void:
	if data.has("days_grown"):
		growth_cycle_component.days_grown = data["days_grown"]
		growth_cycle_component.is_watered = data.get("is_watered", false)
		# Ép cây tự update lại hình dạng
		growth_cycle_component.growth_states()
		growth_cycle_component.harvest_state()
