extends RigidBody2D

enum ANIMAL_STATE { READY, DRAG, RELEASE }

const DRAG_LENGTH: int = 70
const DRAG_LIMIT_MAX: Vector2 = Vector2(DRAG_LENGTH, DRAG_LENGTH)
const DRAG_LIMIT_MIN: Vector2 = Vector2(-DRAG_LENGTH, -DRAG_LENGTH)

const IMPULSE_MULTIPLIER: float = 20.0
const IMPULSE_MAX: float = 1200.0

@onready var label = $Label
@onready var stretch_sound = $StretchSound
@onready var launch_sound = $LaunchSound
@onready var kick_sound = $KickSound
@onready var arrow = $Arrow

var _state: ANIMAL_STATE = ANIMAL_STATE.READY

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO

var _arrow_scale_x: float = 0.0

var _last_collision_count: int = 0

func _ready():
	_start = position
	arrow.hide()
	_arrow_scale_x = arrow.scale.x
	
func _physics_process(delta):
	label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y]
	
	detect_release()
	
	update(delta)
	
func get_impulse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MULTIPLIER
	
func set_release():
	freeze = false
	arrow.hide()
	apply_central_impulse(get_impulse())
	launch_sound.play()
	
func set_drag():
	_drag_start = get_global_mouse_position()
	arrow.show()
	
func set_new_state(new_state: ANIMAL_STATE):
	_state = new_state
	
	if _state == ANIMAL_STATE.RELEASE:
		set_release()
	elif _state == ANIMAL_STATE.DRAG:
		set_drag()
	
func detect_release():
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false

func scale_arrow() -> void:
	var impulse_length = get_impulse().length()
	var impulse_percentage = impulse_length / IMPULSE_MAX
	
	arrow.scale.x = (_arrow_scale_x * impulse_percentage) + _arrow_scale_x 
	arrow.rotation = (_start - position).angle()

func play_stretch_sound() -> void:
	var movement = _last_dragged_vector - _dragged_vector
	if movement.length() > 0:
		if stretch_sound.playing == false:
			stretch_sound.play()

func get_dragged_vector(mouse_position: Vector2) -> Vector2:
	return mouse_position - _drag_start
	
func drag_in_limits() -> void:
	
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x, 
		DRAG_LIMIT_MIN.x, 
		DRAG_LIMIT_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y, 
		DRAG_LIMIT_MIN.y, 
		DRAG_LIMIT_MAX.y
	)
	
	position = _start + _dragged_vector

func update_drag():
	
	if detect_release() == true:
		return
	
	var mouse_position = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(mouse_position)
	play_stretch_sound()
	drag_in_limits()
	
	scale_arrow()
	
func play_collision():
	if (_last_collision_count == 0 and 
	get_contact_count() > 0 and 
	kick_sound.playing == false) :
		kick_sound.play()
	
	_last_collision_count = get_contact_count()
			

func update_flight():
	play_collision()

func update(_delta: float):
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()
		ANIMAL_STATE.RELEASE:
			update_flight()
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	die()

func die():
	SignalManager.animal_died.emit()
	queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)

func _on_sleeping_state_changed():
	if sleeping:
		call_deferred("die")
