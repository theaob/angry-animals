extends Control

const MAIN = preload("res://scenes/main/main.tscn")

@onready var level_complete_container = $MarginContainer/LevelCompleteContainer
@onready var level_complete_sound = $LevelCompleteSound

@onready var level_label = $MarginContainer/VBoxContainer/LevelLabel
@onready var attempts_label = $MarginContainer/VBoxContainer/AttemptsLabel

func _ready():
	SignalManager.level_completed.connect(_on_level_complete)
	SignalManager.score_updated.connect(update_attempts)
	level_label.text = "LEVEL %s" % ScoreManager.get_selected_level() 
	update_attempts(0)
	
func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_packed(MAIN)

func update_attempts(attempts: int):
	attempts_label.text = "ATTEMPTS %s" % attempts

func _on_level_complete():
	level_complete_container.visible = true
	level_label.visible = false
	attempts_label.visible = false
	level_complete_sound.play()
