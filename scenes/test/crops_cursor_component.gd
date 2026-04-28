class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer  
@export var crop_fields_parent: Node2D               
@export var corn_scene: PackedScene    
@export var tomato_scene: PackedScene  

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var global_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
		if event.is_action_pressed("hit"):
			get_cell_under_mouse()
			plant_crop()

func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	
	var local_pos = tilled_soil_tilemap_layer.map_to_local(cell_position)
	global_cell_position = tilled_soil_tilemap_layer.to_global(local_pos)
	distance = player.global_position.distance_to(global_cell_position)

func plant_crop() -> void:
	if distance < 40.0 and cell_source_id != -1:
		if is_cell_empty(global_cell_position):
			var crop_instance = null
			
			if ToolManager.selected_tool == DataTypes.Tools.PlantCorn and corn_scene:
				if InventoryManager.remove_item("corn_seed", 1): 
					crop_instance = corn_scene.instantiate()
				else:
					print("Hệ thống: Mày hết hạt Ngô rồi!")
					
			elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato and tomato_scene:
				if InventoryManager.remove_item("tomato_seed", 1): 
					crop_instance = tomato_scene.instantiate()
				else:
					print("Hệ thống: Mày hết hạt Cà chua rồi!")
				
			if crop_instance:
				crop_instance.global_position = global_cell_position
				crop_fields_parent.add_child(crop_instance)
				# GỌI TỔNG ĐÀI: Tiếng gieo hạt xuống đất
				AudioManager.play_sfx("sfx_chop.ogg") 
		else:
			print("Hệ thống: Chỗ này có cây rồi, không gieo đè được!")

func is_cell_empty(check_pos: Vector2) -> bool:
	for crop in crop_fields_parent.get_children():
		if crop.global_position == check_pos:
			return false
	return true
