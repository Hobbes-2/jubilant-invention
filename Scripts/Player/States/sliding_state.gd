extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sliding_state_physics_processing(delta: float) -> void:
	player_controller.camera_controller.update_camera_pos(delta, -1)

	if player_controller.input_dir.length() == 0 and player_controller.velocity.length() < 0.5:
		player_controller.state_chart.send_event("onIdle")
	elif player_controller.input_dir.length() == 0 and Input.is_action_pressed("Forward"):
		player_controller.state_chart.send_event("onWalking")
		#player_controller.current_lerp_acc = player_controller.WALK_LERP_ACC
		#player_controller.current_lerp_dec = player_controller.WALK_LERP_DEC


func _on_sliding_state_entered() -> void:
	#player_controller.current_movement = player_controller.movement_states.SLIDING
	#player_controller.current_posture = player_controller.posture_states.SLIDING
	pass
		#player_controller.state_chart.send_event("onSliding")
