extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sprinting_state_physics_processing(delta: float) -> void:
	
	if player_controller.input_dir.length() == 0 and player_controller.velocity.length() < 0.5:
		player_controller.state_chart.send_event("onIdle")
	if Input.is_action_just_released("Sprint"):
		player_controller.state_chart.send_event("onWalking")
		#player_controller.current_lerp_dec = player_controller.WALK_LERP_ACC
		#player_controller.current_lerp_acc = player_controller.WALK_LERP_DEC
	#if Input.is_action_pressed("Sprint") and Input.is_action_pressed("Crouch"):
		#player_controller.state_chart.send_event("onSliding")


func _on_sprinting_state_entered() -> void:
	#player_controller.current_movement = player_controller.movement_states.SPRINTING
	pass
