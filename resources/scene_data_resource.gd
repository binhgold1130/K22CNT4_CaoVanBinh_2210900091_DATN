class_name SceneDataResource
extends Resource

# 1. Trạng thái Player
@export var player_pos: Vector2

# 2. Hệ thống thời gian
@export var day: int
@export var hour: int
@export var minute: int

# 3. Quản lý cây cối và các đối tượng động
@export var saved_nodes: Array[NodeDataResource] = []

# 4. Quản lý các ô đất đã cày (Tilled Soil)
@export var saved_tilled_soil: Array[TileDataResource] = []
