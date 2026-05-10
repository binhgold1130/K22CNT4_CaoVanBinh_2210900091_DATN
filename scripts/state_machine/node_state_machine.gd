class_name NodeStateMachine
extends Node

# 1. Khai báo trạng thái khởi đầu và các biến lưu trữ danh sách trạng thái
@export var initial_state: NodeState

var states: Dictionary = {}
var current_state: NodeState
var current_state_name: String

func _ready() -> void:
	# 2. Quét các Node con để đăng ký vào từ điển và kết nối tín hiệu chuyển đổi trạng thái
	for child in get_children():
		if child is NodeState:
			states[child.name.to_lower()] = child
			child.transition.connect(Callable(self, "transition_to"))

	# 3. Kích hoạt trạng thái mặc định ban đầu nếu đã được thiết lập
	if initial_state:
		current_state = initial_state
		current_state_name = current_state.name.to_lower()
		current_state.enter()

# 4. Truyền sự kiện đầu vào (Input Event) xuống cho trạng thái hiện hành xử lý
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _process(delta: float) -> void:
	# 5. Cập nhật logic liên tục mỗi khung hình (Frame) cho trạng thái hiện tại
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	# 6. Cập nhật logic vật lý và liên tục kiểm tra các điều kiện để chuyển trạng thái
	if current_state:
		current_state.physics_process(delta)
		current_state.check_transition()

func transition_to(state_name: String) -> void:
	# 7. Kiểm tra tính hợp lệ của trạng thái mới và chặn nếu đang ở chính trạng thái đó
	if state_name == null || state_name.to_lower() == current_state_name:
		return

	var new_state: NodeState = states.get(state_name.to_lower())
	if new_state == null:
		return

	# 8. Gọi hàm thoát (exit) để dọn dẹp dữ liệu của trạng thái cũ
	if current_state:
		current_state.exit()

	# 9. Gọi hàm bắt đầu (enter) của trạng thái mới và cập nhật lại biến theo dõi
	new_state.enter()
	current_state = new_state
	current_state_name = state_name.to_lower()

	# 10. In log thông báo ra màn hình Console khi kích hoạt các trạng thái hành động đặc thù
	if current_state_name != "idle" and current_state_name != "walk":
		print("🚀 Action State:", current_state_name)
