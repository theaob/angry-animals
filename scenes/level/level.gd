extends Node2D

const ANIMAL = preload("res://scenes/animal/animal.tscn")
const MAIN = preload("res://scenes/main/main.tscn")

@onready var animal_start = $AnimalStart

func _ready():
	add_animal()
	SignalManager.animal_died.connect(_on_animal_died)
	
func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)
	
func add_animal():
	var animal_instance = ANIMAL.instantiate()
	animal_instance.position = animal_start.position
	add_child(animal_instance)

func _on_animal_died():
	add_animal()
