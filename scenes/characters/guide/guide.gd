class_name Guide
extends Node2D 

const GUIDE_DIALOGUE = preload("res://dialogue/conversations/guide.dialogue")
const BALLOON_SCENE = preload("res://dialogue/game_dialogue_balloon.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label: Control = $InteractableLabelComponent

func _ready() -> void:
	if interactable_label != null:
		interactable_label.hide()

	if animated_sprite_2d.sprite_frames.has_animation("idle"):
		animated_sprite_2d.play("idle")
	elif animated_sprite_2d.sprite_frames.has_animation("default"):
		animated_sprite_2d.play("default")
		
	if interactable_component != null:
		interactable_component.interactable_activated.connect(_on_interactable_activated)
		interactable_component.interactable_deactivated.connect(_on_interactable_deactivated)
		interactable_component.interacted.connect(_on_player_interacted)

func _on_interactable_activated() -> void:
	if interactable_label != null:
		interactable_label.show()

func _on_interactable_deactivated() -> void:
	if interactable_label != null:
		interactable_label.hide()

func _on_player_interacted() -> void:
	# An toàn tuyệt đối: Tự tạo Scene khung thoại, không qua Singleton của Plugin
	var balloon = BALLOON_SCENE.instantiate()
	get_tree().current_scene.add_child(balloon)
	
	# Nếu cái khung thoại vẫn hoạt động, nó sẽ chạy kịch bản
	if balloon.has_method("start"):
		balloon.start(GUIDE_DIALOGUE, "start")
