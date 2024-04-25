extends Node

const DEFAULT_SCORE: int = 1000

var _level_scores: Dictionary = {}

var _selected_level: int = 1

func _ready():
	pass

func set_selected_level(level: int) -> void:
	_selected_level = level

func get_selected_level() -> int:
	return _selected_level

func ensure_key_existance(level: String):
	if _level_scores.has(level) == false:
		_level_scores[level] = DEFAULT_SCORE

func set_score_for_level(score: int, level: String):
	if _level_scores[level] > score:
		_level_scores[level] = score

func get_best_for_level(level: String) -> int:
	ensure_key_existance(level)
	return _level_scores[level]
