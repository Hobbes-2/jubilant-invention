extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_airborne_state_physics_processing(delta: float) -> void:
	if player_controller.is_on_floor():
		player_controller.state_chart.send_event("onGrounded")
