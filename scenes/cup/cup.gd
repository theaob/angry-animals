extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func die():
	animation_player.play("vanish")

func _on_animation_player_animation_finished(_anim_name):
	SignalManager.cup_destroyed.emit()
	queue_free()
