class_name GrowthCycleComponent
extends Node

# 1. Khai báo các biến thiết lập
@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed # Trạng thái bắt đầu
@export_range(1, 365) var days_until_harvest: int = 3 # Số ngày TƯỚI NƯỚC cần thiết để thu hoạch

# Tín hiệu phát ra khi chuyển giai đoạn
signal crop_maturity    # Báo hiệu cây đã ra trái/hoa (Đã lớn)
signal crop_harvesting  # Báo hiệu cây đã chín, sẵn sàng hái

# 2. Khai báo các biến theo dõi thời gian thực
var is_watered: bool    # Cờ kiểm tra xem hôm nay cây đã được tưới chưa
var current_day: int    # Ngày hiện tại trong game
var days_grown: int = 0 # Bộ đếm tuổi thọ thực tế của cây (Chỉ tăng khi được tưới)

# 3. Khởi tạo và kết nối với Đồng hồ thế giới
func _ready() -> void:
	# Lắng nghe sự kiện qua ngày mới từ Manager
	if DayAndNightCycleManager:
		DayAndNightCycleManager.time_tick.connect(on_time_tick_day)

# 4. Logic xử lý mỗi khi game bước sang ngày mới (00:00)
func on_time_tick_day(day: int, _hour: int, _minute: int) -> void:
	# Chống spam: Đảm bảo logic chỉ chạy 1 lần duy nhất mỗi ngày
	if current_day == day:
		return
	current_day = day

	# Nếu hôm qua cây ĐÃ ĐƯỢC TƯỚI -> Cho phép cây lớn thêm 1 ngày tuổi
	if is_watered:
		days_grown += 1 
		
		# Gọi hàm tính toán chuyển đổi hình ảnh và trạng thái
		growth_states()
		harvest_state()
		
		# Reset lại trạng thái đất khô, bắt người chơi hôm nay phải tưới tiếp
		#is_watered = false

# 5. Hàm tính toán giai đoạn phát triển (Mầm -> Cây Non -> Ra Hoa)
func growth_states() -> void:
	# Nếu cây đã đạt cảnh giới cao nhất thì không cần tính hình ảnh sinh trưởng nữa
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
		
	var num_states = 4 # Tổng số giai đoạn trước khi chín
	
	# Tính toán State Index: Tuổi của cây sẽ quyết định hình ảnh nó đang ở frame nào
	var state_index = clampi(days_grown, 0, num_states)
	current_growth_state = state_index as DataTypes.GrowthStates
	
	# Bắn tín hiệu nếu cây vừa đạt đến trạng thái trưởng thành (Maturity)
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

# 6. Hàm kiểm tra điều kiện thu hoạch
func harvest_state() -> void:
	# Nếu đã ở trạng thái thu hoạch rồi thì đứng im
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
		
	# Nếu số ngày ĐÃ LỚN đạt đủ chỉ tiêu -> Chuyển sang trạng thái có quả (Harvesting)
	if days_grown >= days_until_harvest:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

# 7. Hàm hỗ trợ lấy trạng thái hiện tại (Dùng cho Scene bên ngoài đọc Data)
func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state

# 8. Hàm nhận lệnh tưới nước (Dùng khi bình tưới tương tác trúng)
func water_crop() -> void:
	is_watered = true
	#print("💦 Đã tưới nước thành công!")
