class_name PlayerStateMachine extends Node

#var current_posture
#var current_movement : AtomicState

@export var debug : bool = false

@export_category("Refrences")

@export var player_controller : PlayerController
#@onready var player_controller: PlayerController = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if debug:
		print("Player controller is:", player_controller)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_controller:
		player_controller.state_chart.set_expression_property("Position", player_controller.position)
		player_controller.state_chart.set_expression_property("Velocity", player_controller.velocity)
		player_controller.state_chart.set_expression_property("Player hitting head", player_controller.crouch_check.is_colliding())
		player_controller.state_chart.set_expression_property("Looking at: ", player_controller.interaction_raycast.current_obj)
