class_name DayNightCycleComponent
extends CanvasModulate

@export var day_night_gradient_texture: GradientTexture1D

func _ready() -> void:
	# Chỉ việc lắng nghe Autoload phát tín hiệu
	if DayAndNightCycleManager:
		DayAndNightCycleManager.game_time.connect(on_game_time)

func on_game_time(time: float) -> void:
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	
	if day_night_gradient_texture != null:
		color = day_night_gradient_texture.gradient.sample(sample_value)
