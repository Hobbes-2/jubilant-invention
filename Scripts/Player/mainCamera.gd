class_name CameraController extends Node3D

@export var debug : bool = false
const RAY_LENGTH = 1000.0
var default_height : float = 0.5
@export_group("Crouch Vertical")
@export var crouching_offset : float = 0.0
@export var crouching_speed : float = 3.0
@export_category("Refrences")
@export var player_controller : PlayerController
@export var mouse_capture: mouse_capture_component
@export_category("Camera Settings")
@export_group("Cam tilt")
@export_range(-90, -60) var tilt_lower_lim := -90
@export_range(60, 90) var tilt_upper_lim := 90
var win = load("res://Scenes/Win.tscn")
var _rotation : Vector3

func update_cam_rotation(input : Vector2) -> void:
	_rotation.x += input.y
	_rotation.y += input.x
	#This IS jus =, NOT and i repeat NOTT += (for the clamp)
	_rotation.x = clamp(_rotation.x, deg_to_rad(tilt_lower_lim), deg_to_rad(tilt_upper_lim))

	var _player_rotation = Vector3(0.0, _rotation.y, 0.0)
	var _camera_rotation = Vector3(_rotation.x, 0.0, 0.0)
	
	transform.basis = Basis.from_euler(_camera_rotation)
	player_controller.update_player_rotation(_player_rotation)
	
	rotation.z = 0.0
	if debug:
		print("Rotation: ", _rotation.x, ", " , _rotation.y, ", " , _rotation.z)
		print("Input: ", input.x, "," , input.y)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_cam_rotation(mouse_capture._mouse_input)

func _input(event):
	pass

func update_camera_pos(delta : float, direction : int) -> void:
	if position.y >= crouching_offset and position.y <= default_height:
		position.y = clampf(position.y + (crouching_speed * direction) * delta, crouching_offset, default_height)
