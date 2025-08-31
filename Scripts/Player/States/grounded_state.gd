extends PlayerState


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_grounded_state_physics_processing(delta: float) -> void:
	if Input.is_action_just_pressed("Jump") and not player_controller.is_on_floor():
		player_controller.state_chart.send_event("onAirborne")
	if not player_controller.is_on_floor():
		player_controller.state_chart.send_event("onAirborne")
