class_name DamageComponent
extends Node2D

@export var max_damage: int = 3
@export var current_damage: int = 0

signal damaged(amount: int)
signal max_damaged_reached

var destroyed := false


func reset_damage() -> void:
	current_damage = 0
	destroyed = false


func apply_damage(damage: int) -> void:
	if destroyed:
		return

	current_damage = clamp(current_damage + damage, 0, max_damage)

	print("💥 Damage:", damage, "|", current_damage, "/", max_damage)

	damaged.emit(damage)

	if current_damage >= max_damage:
		destroyed = true
		max_damaged_reached.emit()
