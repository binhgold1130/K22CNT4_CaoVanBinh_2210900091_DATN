# res://scenes/objects/chest/chest.gd
extends Node2D 

const BALLOON_SCENE = preload("res://dialogue/game_dialogue_balloon.tscn")

@export var pasture_dialogue: DialogueResource 
@export var dialogue_start_title: String = "" 
@export var animal_type: String = "" 
@export var flying_item_texture: Texture2D 

# [MỚI] Mảng chứa các vật phẩm rớt ra (Trứng, Sữa). Tạo giao diện giống Hình 3
@export var output_reward_scenes: Array[PackedScene]

@onready var interactable_component = $InteractableComponent
@onready var interactable_label = $InteractableLabelComponent # [MỚI] Lấy Node chữ E
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready() -> void:
	# [MỚI] Mặc định ẩn nút E lúc mới vào game
	if interactable_label:
		interactable_label.hide()

	if interactable_component:
		interactable_component.interacted.connect(_on_interacted)
		
		# [MỚI] Bắt sự kiện lại gần và đi xa để Hiện/Ẩn nút E
		if interactable_component.has_signal("interactable_activated"):
			interactable_component.interactable_activated.connect(_on_activated)
			interactable_component.interactable_deactivated.connect(_on_deactivated)
		
	GameDialogueManager.animal_fed.connect(_on_animal_fed)

	if animated_sprite_2d:
		pass # animated_sprite_2d.play("empty")

# [MỚI] Hàm hiện nút E khi vào vùng
func _on_activated():
	if interactable_label: interactable_label.show()

# [MỚI] Hàm ẩn nút E khi ra khỏi vùng
func _on_deactivated():
	if interactable_label: interactable_label.hide()

func _on_interacted() -> void:
	if pasture_dialogue != null and dialogue_start_title != "":
		var balloon = BALLOON_SCENE.instantiate()
		get_tree().current_scene.add_child(balloon)
		
		if balloon.has_method("start"):
			balloon.start(pasture_dialogue, dialogue_start_title)
	else:
		print("Hệ thống: Chưa thiết lập kịch bản cho Máng ăn này!")

func _on_animal_fed(fed_animal_type: String) -> void:
	if fed_animal_type == animal_type:
		_spawn_flying_item()
		
		if animated_sprite_2d:
			pass # animated_sprite_2d.play("full")
			
		# [MỚI] Gọi hàm rớt trứng/sữa
		_drop_reward()

# [MỚI] Hàm sinh ra đồ sau khi ăn
func _drop_reward() -> void:
	# Nếu mày chưa kéo thả trứng/sữa vào thì bỏ qua
	if output_reward_scenes.is_empty() or output_reward_scenes[0] == null: 
		return
	
	# Đợi 0.5s để xem xong cái hiệu ứng đồ ăn bay vào máng rồi mới đẻ đồ
	await get_tree().create_timer(0.5).timeout
	
	# Lấy scene đầu tiên trong mảng (mảng có size 1 như hình mày gửi)
	var reward_scene = output_reward_scenes[0]
	var reward_instance = reward_scene.instantiate()
	
	# Rớt đồ ra ngay vị trí cái máng, nhưng xê dịch xuống dưới một chút (y + 15) cho đỡ đè lên nhau
	reward_instance.global_position = global_position + Vector2(0, 15)
	
	# Thêm vào game
	get_tree().current_scene.add_child(reward_instance)
	print("Hệ thống: Vật nuôi đã sản xuất!")

func _spawn_flying_item() -> void:
	if flying_item_texture == null: return
	var player = get_tree().get_first_node_in_group("player")
	if not player: return

	var fake_item = Sprite2D.new()
	fake_item.texture = flying_item_texture
	fake_item.global_position = player.global_position
	fake_item.z_index = 100 
	
	get_tree().current_scene.add_child(fake_item)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(fake_item, "global_position", global_position, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fake_item, "scale", Vector2(0.5, 0.5), 0.5)
	tween.chain().tween_callback(fake_item.queue_free)
