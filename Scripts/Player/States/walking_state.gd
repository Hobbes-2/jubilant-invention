extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_walking_state_physics_processing(delta: float) -> void:
	if Input.is_action_pressed("Sprint"):
		player_controller.state_chart.send_event("onSprinting")
		#player_controller.current_lerp_acc = player_controller.SPRINT_LERP_ACC
		#player_controller.current_lerp_dec = player_controller.SPRINT_LERP_DEC



func _on_walking_state_entered() -> void:
	#player_controller.current_movement = player_controller.movement_states.WALKING
	pass
