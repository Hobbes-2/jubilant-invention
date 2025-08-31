class_name mouse_capture_component extends Node

@export var camera_controller: CameraController
@export var player_controller : PlayerController
@export var debug : bool = false
@export_category("Mouse Capture Settings")
@export var current_mouse_mode : Input.MouseMode = Input.MOUSE_MODE_CAPTURED
@export var sens = 0.003

var capture_mouse : bool
var _mouse_input : Vector2

# Called when the node enters the scene tree for the first time.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == (Input.MOUSE_MODE_CAPTURED):
		camera_controller.rotate_y(-event.relative.x * sens)
		camera_controller.rotate_x(-event.relative.y * sens)
		
		#mouse_input.x += -event.relative.x * sens;
		#mouse_input.y += -event.relative.y * sens;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	capture_mouse = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if capture_mouse:
	#if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_input.x = -event.relative.x * sens
		_mouse_input.y = -event.relative.y * sens
	if debug:
		player_controller.state_chart.set_expression_property("Mouse Input:", _mouse_input)


func _ready() -> void:
	Input.mouse_mode = current_mouse_mode


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_mouse_input = Vector2.ZERO
