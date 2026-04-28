class_name SceneDataResource
extends Resource

# 1. Trạng thái Player
@export var player_pos: Vector2

# 2. Thời gian
@export var day: int
@export var hour: int
@export var minute: int

# 3. Cây cối
@export var saved_nodes: Array[NodeDataResource] = []

# ==================================
# 4. ĐẤT CÀY (THÊM DÒNG NÀY VÀO)
# ==================================
@export var saved_tilled_soil: Array[TileDataResource] = []
