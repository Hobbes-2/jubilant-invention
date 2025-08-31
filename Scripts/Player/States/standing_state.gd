extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_standing_state_physics_processing(delta: float) -> void:
	player_controller.camera_controller.update_camera_pos(delta, 1)

	if Input.is_action_just_pressed("Crouch") and player_controller.crouching == true:
		player_controller.state_chart.send_event("onCrouching")
		#player_controller.current_lerp_acc = player_controller.CROUCH_LERP_ACC
		#player_controller.current_lerp_dec = player_controller.CROUCH_LERP_DEC
	if player_controller.sliding == true:
		player_controller.state_chart.send_event("onSliding")


func _on_standing_state_entered() -> void:
	player_controller.stand_up()
	#player_controller.current_posture = player_controller.posture_states.STANDING
