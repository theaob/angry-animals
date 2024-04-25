extends Node

const DEFAULT_SCORE: int = 1000
const SCORES_PATH = "user://animals.json"

var _level_scores: Dictionary = {}

var _selected_level: int = 1

func _ready():
	load_from_disk()

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
		save_to_disk()

func get_best_for_level(level: String) -> int:
	ensure_key_existance(level)
	return _level_scores[level]
	
func save_to_disk():
	var file = FileAccess.open(SCORES_PATH, FileAccess.WRITE)
	var score_json = JSON.stringify(_level_scores)
	file.store_string(score_json)
	
func load_from_disk():
	var file = FileAccess.open(SCORES_PATH, FileAccess.READ)
	
	if file == null:
		# file does not exist
		save_to_disk()
		return
	
	var data = file.get_as_text()
	_level_scores = JSON.parse_string(data)
