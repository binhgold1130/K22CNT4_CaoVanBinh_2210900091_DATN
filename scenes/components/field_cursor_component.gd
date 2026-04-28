class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer        
@export var tilled_soil_tilemap_layer: TileMapLayer  
@export var terrain_set: int = 0                     
@export var terrain: int = 3                         
@export var crop_fields_parent: Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2      
var cell_position: Vector2i      
var cell_source_id: int          
var local_cell_position: Vector2 
var distance: float              

func _unhandled_input(event: InputEvent) -> void:
	if ToolManager.selected_tool == DataTypes.Tools.TillGround:
		if event.is_action_pressed("remove_dirt"):
			get_cell_under_mouse()
			remove_tilled_soil_cell()
		elif event.is_action_pressed("hit"):
			get_cell_under_mouse()
			add_tilled_soil_cell()

func get_cell_under_mouse() -> void:
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func add_tilled_soil_cell() -> void:
	if distance < 40.0 and cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
		# GỌI TỔNG ĐÀI: Tiếng cuốc đất "Phập!"
		AudioManager.play_sfx("sfx_chop.ogg")

func remove_tilled_soil_cell() -> void:
	if distance < 40.0:
		# Lấy tâm của ô đất để so sánh với tọa độ gốc của cây
		var map_pos_to_local = tilled_soil_tilemap_layer.map_to_local(cell_position)
		var global_cell_pos = tilled_soil_tilemap_layer.to_global(map_pos_to_local)
		
		# Quét và nhổ cây
		if crop_fields_parent:
			for crop in crop_fields_parent.get_children():
				if crop.global_position.distance_to(global_cell_pos) < 1.0:
					crop.queue_free()
		
		# Lấp đất
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, -1, true)
		# GỌI TỔNG ĐÀI: Tiếng dọn đất 
		AudioManager.play_sfx("sfx_chop.ogg")
