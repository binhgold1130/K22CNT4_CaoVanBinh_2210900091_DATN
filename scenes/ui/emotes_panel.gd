extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D

func _ready() -> void:
	# Khung chat hiện lên là cho chạy cái animation đứng thở (hoặc đang nói)
	if animated_sprite_2d != null:
		# [ĐÃ SỬA] Đổi "default" thành tên chính xác trong list của mày
		animated_sprite_2d.play("emote_1_idle") 

# Hàm dùng để đổi mặt NPC (lúc vui buồn)
func play_emote(animation_name: String) -> void:
	if animated_sprite_2d != null and animated_sprite_2d.sprite_frames.has_animation(animation_name):
		animated_sprite_2d.play(animation_name)
