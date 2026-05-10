class_name Guide
extends Node2D 

# 1. Tải trước tài nguyên kịch bản hội thoại và Scene khung thoại (Balloon)
const GUIDE_DIALOGUE = preload("res://dialogue/conversations/guide.dialogue")
const BALLOON_SCENE = preload("res://dialogue/game_dialogue_balloon.tscn")

# 2. Khai báo các thành phần điều khiển hoạt ảnh và tương tác
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label: Control = $InteractableLabelComponent

func _ready() -> void:
	# 3. Khởi tạo trạng thái ban đầu: Ẩn nhãn tương tác và chạy hoạt ảnh đứng im
	if interactable_label != null:
		interactable_label.hide()

	if animated_sprite_2d.sprite_frames.has_animation("idle"):
		animated_sprite_2d.play("idle")
	elif animated_sprite_2d.sprite_frames.has_animation("default"):
		animated_sprite_2d.play("default")
		
	# 4. Kết nối các tín hiệu từ thành phần tương tác (InteractableComponent)
	if interactable_component != null:
		interactable_component.interactable_activated.connect(_on_interactable_activated)
		interactable_component.interactable_deactivated.connect(_on_interactable_deactivated)
		interactable_component.interacted.connect(_on_player_interacted)

func _on_interactable_activated() -> void:
	# 5. Hiển thị nhãn hướng dẫn khi người chơi tiến lại gần
	if interactable_label != null:
		interactable_label.show()

func _on_interactable_deactivated() -> void:
	# 6. Ẩn nhãn hướng dẫn khi người chơi rời đi
	if interactable_label != null:
		interactable_label.hide()

func _on_player_interacted() -> void:
	# 7. Khởi tạo và hiển thị khung thoại khi người chơi thực hiện tương tác
	var balloon = BALLOON_SCENE.instantiate()
	get_tree().current_scene.add_child(balloon)
	
	# Kích hoạt nội dung hội thoại từ file kịch bản
	if balloon.has_method("start"):
		balloon.start(GUIDE_DIALOGUE, "start")
