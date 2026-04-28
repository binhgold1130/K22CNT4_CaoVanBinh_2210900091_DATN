class_name IdleState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func enter() -> void:
	play_idle_animation()

# 🔥 Dùng handle_input để chặn click xuyên UI
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		match player.current_tool:
			DataTypes.Tools.AxeWood: transition.emit("chopping")
			DataTypes.Tools.TillGround: transition.emit("tilling")
			DataTypes.Tools.WaterCrops: transition.emit("watering")

func physics_process(_delta: float) -> void:
	direction = GameInputEvents.movement_input()
	if direction != Vector2.ZERO:
		player.set_direction(direction)
		play_idle_animation()

func check_transition() -> void:
	# Chỉ check chuyển sang walk ở đây
	if direction != Vector2.ZERO:
		transition.emit("walk")

func play_idle_animation() -> void:
	var dir = player.last_direction
	if dir.y < 0: animated_sprite_2d.play("idle_back")
	elif dir.y > 0: animated_sprite_2d.play("idle_front")
	elif dir.x > 0: animated_sprite_2d.play("idle_right")
	elif dir.x < 0: animated_sprite_2d.play("idle_left")
