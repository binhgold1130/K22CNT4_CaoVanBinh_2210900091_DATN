class_name TillingState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 = Vector2.DOWN


func enter() -> void:
	# 🔥 lấy hướng cuối
	direction = player.last_direction

	# dừng nhân vật
	player.velocity = Vector2.ZERO

	_play_till_animation()


func physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()


func check_transition() -> void:
	if not animated_sprite_2d.is_playing():
		transition.emit("idle")


# 🎬 animation
func _play_till_animation():
	if direction.y < 0:
		animated_sprite_2d.play("tilling_back")
	elif direction.y > 0:
		animated_sprite_2d.play("tilling_front")
	elif direction.x > 0:
		animated_sprite_2d.play("tilling_right")
	elif direction.x < 0:
		animated_sprite_2d.play("tilling_left")
