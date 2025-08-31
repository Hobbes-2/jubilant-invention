extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_crouching_state_physics_processing(delta: float) -> void:
	player_controller.camera_controller.update_camera_pos(delta, -1)
	
	if not Input.is_action_pressed("Crouch") and player_controller.is_on_floor() and not player_controller.crouch_check.is_colliding():
		player_controller.state_chart.send_event("onStanding")


func _on_crouching_state_entered() -> void:
	player_controller.crouch()
	#player_controller.current_posture = player_controller.posture_states.CROUCHING
