# res://scenes/components/feed_component.gd
extends Area2D

signal food_added(type: String)
@export var animal_type: String = ""

func try_to_feed() -> bool:
	var selected = ToolManager.selected_tool 
	var item_name = ""
	
	if selected == DataTypes.Tools.PlantCorn: item_name = "corn"
	elif selected == DataTypes.Tools.PlantTomato: item_name = "tomato"
		
	if item_name == "": return false

	if InventoryManager.remove_item(item_name, 1): 
		# Phát tín hiệu báo cho hệ thống biết là con vật đã ăn
		GameDialogueManager.animal_fed.emit(animal_type)
		food_added.emit(item_name)
		return true
	else:
		print("Hệ thống: Hết ", item_name, " rồi!")
		return false
