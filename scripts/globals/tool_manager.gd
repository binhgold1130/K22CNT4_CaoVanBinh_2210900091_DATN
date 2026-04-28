extends Node

# Biến global lưu trữ món đồ nào đang được chọn trên toàn hệ thống
var selected_tool: DataTypes.Tools = DataTypes.Tools.None

# Tín hiệu phát đi để Player và UI Hotbar biết mà cập nhật hình ảnh hiển thị
signal tool_selected(tool: DataTypes.Tools)

# Hàm duy nhất để thay đổi công cụ (gọi từ Hotbar hoặc phím tắt Player)
func select_tool(tool: DataTypes.Tools) -> void:
	selected_tool = tool
	tool_selected.emit(selected_tool)
