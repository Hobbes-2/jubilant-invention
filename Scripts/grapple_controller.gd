extends Node

@export var ray: RayCast3D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

@onready var player_controller: PlayerController = $"../.."
@onready var rope: Node3D = $"../../CameraController/Rope"

var target = Vector3()

var launched = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		launch()
	if Input.is_action_just_released("Shoot"):
		release()
		
	if launched:
		handle_grapple(delta)
	update_rope()

func launch():
	if ray.is_colliding():
		target = ray.get_collision_point()
		launched = true

func release():
	launched = false
	

func handle_grapple(delta : float):
	var target_dir = player_controller.global_position.direction_to(target)
	var target_dist = player_controller.global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	var force = Vector3.ZERO
	
	if displacement > 0:
		var spring_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_magnitude
		
		var vel_dot = player_controller.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
		
		player_controller.velocity += force * delta

func update_rope():
	if !launched:
		rope.visible = false
		return
	
	rope.visible = true
	
	var dist = player_controller.global_position.distance_to(target)
	
	rope.look_at(target)
	rope.scale = Vector3(1, 1, dist / 2)
	
