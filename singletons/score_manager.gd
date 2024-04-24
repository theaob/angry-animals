extends Node

var _selected_level: int = 1

func _ready():
	pass

func set_selected_level(level: int) -> void:
	_selected_level = level

func get_selected_level() -> int:
	return _selected_level
