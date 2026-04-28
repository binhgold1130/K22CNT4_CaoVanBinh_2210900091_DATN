class_name ChoppingState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

var direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	hit_component_collision_shape.set_deferred("disabled", true)

func enter() -> void:
	direction = player.last_direction
	player.velocity = Vector2.ZERO



	_update_hitbox_position()
	
	# Bật hitbox an toàn
	hit_component_collision_shape.set_deferred("disabled", false)

	_play_chop_animation()

func exit() -> void:
	# CHỈ tắt hitbox, KHÔNG set tool về None nữa
	hit_component_collision_shape.set_deferred("disabled", true)

func physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func check_transition() -> void:
	if not animated_sprite_2d.is_playing():
		# Xóa hết các dòng thừa ở đây, chỉ giữ lại lệnh chuyển state
		transition.emit("idle")

func _play_chop_animation():
	if direction.y < 0:
		animated_sprite_2d.play("chopping_back")
	elif direction.y > 0:
		animated_sprite_2d.play("chopping_front")
	elif direction.x > 0:
		animated_sprite_2d.play("chopping_right")
	elif direction.x < 0:
		animated_sprite_2d.play("chopping_left")


func _update_hitbox_position():
	if direction.y < 0:
		hit_component_collision_shape.position = Vector2(0, -14)
	elif direction.y > 0:
		hit_component_collision_shape.position = Vector2(0, 3)
	elif direction.x > 0:
		hit_component_collision_shape.position = Vector2(8, 0)
	elif direction.x < 0:
		hit_component_collision_shape.position = Vector2(-8, -2)
