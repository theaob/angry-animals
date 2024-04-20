extends Node2D

const ANIMAL = preload("res://scenes/animal/animal.tscn")

@onready var animal_start = $AnimalStart

func _ready():
	add_animal()
	SignalManager.animal_died.connect(_on_animal_died)
	
func add_animal():
	var animal_instance = ANIMAL.instantiate()
	animal_instance.position = animal_start.position
	add_child(animal_instance)

func _on_animal_died():
	add_animal()
