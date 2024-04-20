extends RigidBody2D

@onready var label = $Label

enum ANIMAL_STATE { READY, DRAG, RELEASE }

var _state: ANIMAL_STATE = ANIMAL_STATE.READY

func _ready():
	pass
	
func _physics_process(delta):
	label.text = "%s" % ANIMAL_STATE.keys()[_state]
	
	detect_release()
	
	update(delta)
	
func set_new_state(new_state: ANIMAL_STATE):
	_state = new_state
	
	if _state == ANIMAL_STATE.RELEASE:
		freeze = false
	elif _state == ANIMAL_STATE.DRAG:
		pass
	
func detect_release():
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false

func update_drag():
	
	if detect_release() == true:
		return
	
	var mouse_position = get_global_mouse_position()
	position = mouse_position

func update(delta: float):
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()
		ANIMAL_STATE.RELEASE:
			pass
		

func _on_visible_on_screen_notifier_2d_screen_exited():
	die()

func die():
	SignalManager.animal_died.emit()
	queue_free()

func _on_input_event(viewport, event, shape_idx):
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)
