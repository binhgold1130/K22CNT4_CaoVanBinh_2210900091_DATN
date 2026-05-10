class_name DayNightCycleComponent
extends CanvasModulate

# 1. Tài nguyên Gradient điều khiển màu sắc chuyển đổi theo thời gian
@export var day_night_gradient_texture: GradientTexture1D

func _ready() -> void:
	# 2. Kết nối với trình quản lý thời gian Autoload để cập nhật chu kỳ Ngày/Đêm
	if DayAndNightCycleManager:
		DayAndNightCycleManager.game_time.connect(on_game_time)

func on_game_time(time: float) -> void:
	# 3. Tính toán giá trị mẫu dựa trên hàm Sin để tạo sự chuyển đổi mượt mà
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	
	# 4. Cập nhật màu sắc của màn hình dựa trên tài nguyên Gradient đã thiết lập
	if day_night_gradient_texture != null:
		color = day_night_gradient_texture.gradient.sample(sample_value)
