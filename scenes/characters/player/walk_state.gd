class_name WalkState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func physics_process(_delta: float) -> void:
	direction = GameInputEvents.movement_input()
	player.set_direction(direction)
	_play_walk_animation(direction)

# 🔥 Dùng handle_input để chặn click xuyên UI
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		match player.current_tool:
			DataTypes.Tools.AxeWood: transition.emit("chopping")
			DataTypes.Tools.TillGround: transition.emit("tilling")
			DataTypes.Tools.WaterCrops: transition.emit("watering")

func check_transition() -> void:
	if direction == Vector2.ZERO:
		transition.emit("idle")

func exit() -> void:
	player.set_direction(Vector2.ZERO)

func _play_walk_animation(dir: Vector2) -> void:
	var anim_name = ""
	if dir.y < 0: anim_name = "walk_back"
	elif dir.y > 0: anim_name = "walk_front"
	elif dir.x > 0: anim_name = "walk_right"
	elif dir.x < 0: anim_name = "walk_left"
	
	if anim_name != "" and animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)
