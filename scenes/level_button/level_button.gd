extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var level_number:int = 1

@onready var level_label = $MarginContainer/VBoxContainer/LevelLabel
@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel

var _level_scene: PackedScene

func _ready():
	level_label.text = str(level_number)
	var best_score = ScoreManager.get_best_for_level(str(level_number))
	score_label.text = str(best_score)
	_level_scene = load("res://scenes/level/level_%s.tscn" % level_number)
	
func _on_pressed():
	ScoreManager.set_selected_level(level_number)
	get_tree().change_scene_to_packed(_level_scene)

func _on_mouse_entered():
	scale = HOVER_SCALE
	
func _on_mouse_exited():
	scale = DEFAULT_SCALE
