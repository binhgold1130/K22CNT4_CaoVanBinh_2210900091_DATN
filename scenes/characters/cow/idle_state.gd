class_name CowIdleState
extends NodeState

@export var animated_sprite_2d: AnimatedSprite2D
@export var voice_player: AudioStreamPlayer2D # <-- Ống cắm cái loa 2D (Nhớ kéo Node vào đây)

@export var min_idle_time: float = 4.0 
@export var max_idle_time: float = 8.0

var idle_timer: float = 0.0

func _ready() -> void:
	idle_timer = randf_range(0.5, max_idle_time)

func enter() -> void:
	idle_timer = randf_range(min_idle_time, max_idle_time)
	
	if animated_sprite_2d:
		if randf() > 0.3:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("idle") 
			
		animated_sprite_2d.flip_h = randf() > 0.5
		
	# Bò tự kêu bằng loa đeo cổ, đi xa sẽ nhỏ dần
	if randi() % 100 < 30:
		if voice_player != null and not voice_player.playing:
			voice_player.play()

func exit() -> void:
	pass

func process(delta: float) -> void:
	if idle_timer > 0:
		idle_timer -= delta

func check_transition() -> void:
	if idle_timer <= 0:
		transition.emit("walk")
