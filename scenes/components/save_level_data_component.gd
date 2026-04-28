class_name SaveLevelDataComponent
extends Node

@export var save_data_component: SaveDataComponent 
@export var crop_fields: Node2D                    
@export var tilled_soil_layer: TileMapLayer 

var player: Player 

func _ready() -> void:
	SaveGameManager.save_game.connect(save_level_data)
	SaveGameManager.load_game.connect(load_level_data)
	player = get_tree().get_first_node_in_group("player")
	
	# [MỚI THÊM] Đón lệnh từ Main Menu truyền sang ngay khi vừa load xong Scene
	if SaveGameManager.allow_load_on_start:
		load_level_data() # Kích hoạt tải dữ liệu ngay lập tức
		SaveGameManager.allow_load_on_start = false # Tải xong thì tắt cờ đi để tránh lỗi

func save_level_data() -> void:
	print("Đang thu thập dữ liệu màn chơi...")
	var scene_data = SceneDataResource.new()

	if player != null:
		scene_data.player_pos = player.global_position

	scene_data.day = DayAndNightCycleManager.current_day
	scene_data.hour = DayAndNightCycleManager.current_hour
	scene_data.minute = DayAndNightCycleManager.current_minute

	if crop_fields != null:
		var saved_nodes_array: Array[NodeDataResource] = []
		for crop in crop_fields.get_children():
			var node_data = NodeDataResource.new() 
			node_data._save_data(crop)             
			saved_nodes_array.append(node_data)    
		scene_data.saved_nodes = saved_nodes_array

	if tilled_soil_layer != null:
		var saved_soil_array: Array[TileDataResource] = []
		var used_cells = tilled_soil_layer.get_used_cells()
		for cell_pos in used_cells:
			var tile_data = TileDataResource.new()
			tile_data.cell_position = cell_pos
			tile_data.terrain_set = 0 
			tile_data.terrain_id = 3 
			saved_soil_array.append(tile_data)
		scene_data.saved_tilled_soil = saved_soil_array

	if save_data_component != null:
		save_data_component.save_data_resource = scene_data
		save_data_component.save_game_data()

func load_level_data() -> void:
	if save_data_component == null: return
	var scene_data: SceneDataResource = save_data_component.load_game_data()
	if scene_data == null: return 
		
	print("Đang phục hồi màn chơi...")

	if player != null:
		player.global_position = scene_data.player_pos

	DayAndNightCycleManager.set_time_to(scene_data.day, scene_data.hour, scene_data.minute)

	if crop_fields != null:
		for old_crop in crop_fields.get_children():
			old_crop.queue_free()
			
		for node_data in scene_data.saved_nodes:
			if node_data.scene_file_path != "":
				var crop_scene = load(node_data.scene_file_path) 
				if crop_scene:
					var new_crop = crop_scene.instantiate()      
					new_crop.global_position = node_data.global_position 
					crop_fields.add_child(new_crop)              
					
					# Trả lại tuổi cho cây
					if new_crop.has_method("apply_custom_load_data"):
						new_crop.apply_custom_load_data(node_data.custom_data)

	if tilled_soil_layer != null:
		tilled_soil_layer.clear() 
		var cells_to_till: Array[Vector2i] = []
		for tile_data in scene_data.saved_tilled_soil:
			cells_to_till.append(tile_data.cell_position)
		if cells_to_till.size() > 0:
			var t_set = scene_data.saved_tilled_soil[0].terrain_set
			var t_id = scene_data.saved_tilled_soil[0].terrain_id
			tilled_soil_layer.set_cells_terrain_connect(cells_to_till, t_set, t_id)
