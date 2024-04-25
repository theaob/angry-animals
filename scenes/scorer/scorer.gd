extends Node

var _attemps: int = 0
var _cups_hit: int = 0
var _total_cups: int = 0
var _level_number:int = 1

func _ready():
	_total_cups = get_tree().get_nodes_in_group("cup").size()
	_level_number = ScoreManager.get_selected_level()
	SignalManager.attempt_made.connect(_on_attempt_made)
	SignalManager.cup_destroyed.connect(_on_cup_destroyed)

func _on_attempt_made() -> void:
	_attemps += 1
	SignalManager.score_updated.emit(_attemps)

func _on_cup_destroyed() -> void:
	_cups_hit += 1
	
	if _cups_hit == _total_cups:
		SignalManager.level_completed.emit()
		ScoreManager.set_score_for_level(_attemps, str(_level_number))
