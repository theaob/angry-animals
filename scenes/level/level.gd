extends Node2D

const ANIMAL = preload("res://scenes/animal/animal.tscn")

@onready var animal_start = $AnimalStart

func _ready():
	add_animal()
	SignalManager.animal_died.connect(_on_animal_died)
	SignalManager.level_completed.connect(_on_level_completed)
	
func add_animal():
	var animal_instance = ANIMAL.instantiate()
	animal_instance.position = animal_start.position
	add_child(animal_instance)

func _on_animal_died():
	add_animal()
	
func _on_level_completed():
	var animal_instances = get_tree().get_nodes_in_group("animal")
	
	for animal in animal_instances:
		animal.call_deferred("queue_free")
