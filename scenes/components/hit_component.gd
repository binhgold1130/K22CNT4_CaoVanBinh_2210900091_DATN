class_name HitComponent
extends Area2D

@export var player: Player
var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage: int = 1


func _ready() -> void:
	if player == null:
		player = get_parent() as Player

	if player != null:
		current_tool = player.current_tool
		player.tool_changed.connect(_on_player_tool_changed)


func _process(_delta: float) -> void:
	if player != null:
		current_tool = player.current_tool


func _on_player_tool_changed(tool: DataTypes.Tools) -> void:
	current_tool = tool 
