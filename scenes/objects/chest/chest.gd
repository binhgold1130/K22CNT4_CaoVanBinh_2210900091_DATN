# res://scenes/objects/chest/chest.gd
extends Node2D 

# 1. Tải trước Scene khung thoại để sử dụng khi người chơi tương tác
const BALLOON_SCENE = preload("res://dialogue/game_dialogue_balloon.tscn")

# 2. Khai báo các tài nguyên kịch bản, vật phẩm bay và mảng chứa phần thưởng (Trứng, Sữa)
@export var pasture_dialogue: DialogueResource 
@export var dialogue_start_title: String = "" 
@export var animal_type: String = "" 
@export var flying_item_texture: Texture2D 

# Mảng chứa các PackedScene phần thưởng để rớt ra sau khi vật nuôi ăn xong
@export var output_reward_scenes: Array[PackedScene]

# 3. Lấy các thành phần điều khiển tương tác, nhãn hiển thị và hoạt ảnh
@onready var interactable_component = $InteractableComponent
@onready var interactable_label = $InteractableLabelComponent # Nhãn chữ E hướng dẫn tương tác
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready() -> void:
	# 4. Thiết lập trạng thái ban đầu: Ẩn nhãn tương tác và kết nối các tín hiệu
	if interactable_label:
		interactable_label.hide()

	if interactable_component:
		# Kết nối tín hiệu khi người chơi nhấn phím tương tác
		interactable_component.interacted.connect(_on_interacted)
		
		# Kết nối tín hiệu hiển thị/ẩn nhãn chữ E khi người chơi lại gần hoặc đi xa
		if interactable_component.has_signal("interactable_activated"):
			interactable_component.interactable_activated.connect(_on_activated)
			interactable_component.interactable_deactivated.connect(_on_deactivated)
		
	# Lắng nghe sự kiện từ trình quản lý hội thoại khi vật nuôi đã được cho ăn
	GameDialogueManager.animal_fed.connect(_on_animal_fed)

	if animated_sprite_2d:
		pass 

# 5. Hàm xử lý hiển thị nhãn tương tác khi người chơi bước vào vùng
func _on_activated():
	if interactable_label: interactable_label.show()

# 6. Hàm xử lý ẩn nhãn tương tác khi người chơi rời khỏi vùng
func _on_deactivated():
	if interactable_label: interactable_label.hide()

func _on_interacted() -> void:
	# 7. Khởi tạo hội thoại nếu đã thiết lập kịch bản cho máng ăn
	if pasture_dialogue != null and dialogue_start_title != "":
		var balloon = BALLOON_SCENE.instantiate()
		get_tree().current_scene.add_child(balloon)
		
		if balloon.has_method("start"):
			balloon.start(pasture_dialogue, dialogue_start_title)
	else:
		print("Hệ thống: Chưa thiết lập kịch bản cho Máng ăn này!")

func _on_animal_fed(fed_animal_type: String) -> void:
	# 8. Xử lý logic khi đúng loại động vật được cho ăn
	if fed_animal_type == animal_type:
		_spawn_flying_item() # Tạo hiệu ứng vật phẩm bay từ người chơi tới máng
		
		if animated_sprite_2d:
			pass 
			
		# Kích hoạt rớt phần thưởng (như trứng hoặc sữa)
		_drop_reward()

func _drop_reward() -> void:
	# 9. Logic sinh ra phần thưởng sau một khoảng trễ ngắn
	if output_reward_scenes.is_empty() or output_reward_scenes[0] == null: 
		return
	
	# Đợi hiệu ứng vật phẩm bay hoàn tất trước khi tạo phần thưởng
	await get_tree().create_timer(0.5).timeout
	
	# Khởi tạo phần thưởng từ mảng và đặt vị trí xuất hiện dưới máng ăn
	var reward_scene = output_reward_scenes[0]
	var reward_instance = reward_scene.instantiate()
	
	# Điều chỉnh vị trí y + 15 để vật phẩm không bị đè lên máng
	reward_instance.global_position = global_position + Vector2(0, 15)
	
	get_tree().current_scene.add_child(reward_instance)
	print("Hệ thống: Vật nuôi đã sản xuất!")

func _spawn_flying_item() -> void:
	# 10. Tạo hiệu ứng Tween cho vật phẩm bay từ vị trí Player đến máng ăn
	if flying_item_texture == null: return
	var player = get_tree().get_first_node_in_group("player")
	if not player: return

	var fake_item = Sprite2D.new()
	fake_item.texture = flying_item_texture
	fake_item.global_position = player.global_position
	fake_item.z_index = 100 
	
	get_tree().current_scene.add_child(fake_item)
	
	# Sử dụng Tween để di chuyển và thu nhỏ vật phẩm đồng thời
	var tween = create_tween().set_parallel(true)
	tween.tween_property(fake_item, "global_position", global_position, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fake_item, "scale", Vector2(0.5, 0.5), 0.5)
	
	# Giải phóng vật phẩm sau khi hoàn tất hiệu ứng
	tween.chain().tween_callback(fake_item.queue_free)
