class_name DamageComponent
extends Node2D

# 1. Khai báo các thông số về mức độ hư hại (sát thương)
@export var max_damage: int = 3
@export var current_damage: int = 0

# 2. Tín hiệu phát ra khi nhận sát thương hoặc khi đạt giới hạn phá hủy
signal damaged(amount: int)
signal max_damaged_reached

var destroyed := false


# 3. Hàm đặt lại trạng thái sát thương về ban đầu
func reset_damage() -> void:
	current_damage = 0
	destroyed = false


# 4. Hàm xử lý logic khi đối tượng nhận sát thương
func apply_damage(damage: int) -> void:
	# Nếu đối tượng đã bị phá hủy thì không nhận thêm sát thương
	if destroyed:
		return

	# Cập nhật giá trị sát thương hiện tại trong giới hạn cho phép
	current_damage = clamp(current_damage + damage, 0, max_damage)

	# In thông tin kiểm tra quá trình nhận sát thương ra cửa sổ Output
	print("💥 Damage:", damage, "|", current_damage, "/", max_damage)

	# Phát tín hiệu thông báo lượng sát thương vừa nhận
	damaged.emit(damage)

	# 5. Kiểm tra nếu đạt ngưỡng sát thương tối đa để kích hoạt trạng thái phá hủy
	if current_damage >= max_damage:
		destroyed = true
		max_damaged_reached.emit()
