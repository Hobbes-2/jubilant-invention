class_name PlayerState 
extends Node

@export_category("Refrences")

@export var debug : bool = false


@export var state_machine: PlayerStateMachine

@export var player_controller : PlayerController


func _ready() -> void:
	
	print("Node type:", %StateMachine)
	print("Is PlayerStateMachine?", %StateMachine is PlayerStateMachine)

	if %StateMachine and %StateMachine is PlayerStateMachine:
		player_controller = %StateMachine.player_controller;
	else:
		print("NOOOOOO")

func _process(delta: float) -> void:
	pass
