class_name PlayerController
extends CharacterBody3D


var SPEED = 10.0
const JUMP_VELOCITY = 5
const HOOK_SPEED = 100
var gravity_default = 0.0
var gravity_falling = 15.0
var current_gravity : Vector3
@onready var crouch_check: ShapeCast3D = $CrouchCheck
@onready var aim_node = $CameraController/Aim
@onready var rope_node = $CameraController/Rope
@onready var rope_model_node: CSGCylinder3D
#@export var state_chart : StateChart
@onready var state_chart: StateChart = $StateChart
@onready var Crouching: CollisionShape3D = $Crouching
@onready var Standing: CollisionShape3D = $Standing
@onready var camera: Camera3D = $CameraController/Camera3D
@onready var camera_controller: CameraController = $CameraController
@onready var grapple_raycast: RayCast3D = $CameraController/Camera3D/GrappleRaycast
@onready var head_hitter: RayCast3D = $HeadHitter



@export var interaction_raycast: RayCast3D
@export var ACCELERATION : float = 0.1
@export var DECCELERATION : float = 0.5


var crouching : bool = false

const TARGET_LERP = .8

const SPRINT_SPEED = 18.0
const SPRINT_LERP_ACC = 1
const SPRINT_LERP_DEC = 8

const WALK_SPEED = 6.0
const WALK_LERP_ACC = 3.5
const WALK_LERP_DEC = 10

const CROUCH_SPEED = 3.0
const CROUCH_LERP_ACC = 8
const CROUCH_LERP_DEC = 14

const SLIDE_SPEED = 30
const SLIDE_TIME_MAX = 1.0
const SLIDE_DAMPEN_RATE = 0.05
const SLIDE_FLAT_DAMPEN_RATE = .001
const SLOPE_SLIDE_THRESHOLD = .1

var current_slide_time = 0
var current_slide_vector : Vector2 = Vector2.ZERO
var current_lerp_acc : float = 0.1
var current_lerp_dec : float = 0.1

var walking_speed_modifier = 5
var sprinting_speed_modifier = 20
var crouching_speed_modifier = 7

var current_acc_rate : Vector3 = Vector3.ZERO
var current_sprint_cd = 0
var input_dir : Vector2 = Vector2.ZERO
var is_hooked:bool = false
var shoot_dir: Vector3

var sens = 0.003

#Sliding timers and stuff

var slide_timer = 0.0
var slide_timer_max = 1.0

var on_steep : bool = false

var fall_distance = 0
var slide_speed = 0
var can_slide : bool = false
var sliding : bool = false
var falling : bool = false
@onready var slide_check: RayCast3D = $SlideCheck

#Grappling variables 

var grappling : bool = false
var hookpoint = Vector3()
var hookpoint_get : bool = false
var grapple_position := Vector3()
var max_grapple_speed := 2.75 # Self explanatory
var grapple_speed := .5
var rest_length := 1.0

#GRAPPLING FUNCTIONS -----------------------------------------------------------------------

#func grapple():
	#var length := calculate_path()
	#if Input.is_action_just_pressed("Shoot"):
		#if grapple_raycast.is_colliding():
			#if not grappling:
				#grappling = true
	#if Input.is_action_just_released("Shoot"):
		#grappling = false
		#hookpoint = null
		#hookpoint_get = false
	#if grappling:
		#current_gravity = Vector3()
		#if not hookpoint_get:
			#hookpoint = grapple_raycast.get_collision_point() + Vector3(0, 2.25, 0)
			#hookpoint_get = true
		#if hookpoint.distance_to(transform.origin) > 1:
			#if hookpoint_get:
				#transform.origin = lerp(transform.origin, hookpoint, 0.05)
		#else:
			#grappling = false
			#hookpoint_get = false
	#if head_hitter.is_colliding():
		#grappling = false
		#hookpoint = null
		#hookpoint_get = false
		#global_translate(Vector3(0, -1, 0))
#
## Adds to player velocity and returns the length of the hook rope
#func calculate_path() -> float:
	#var player2hook := grapple_position - position # vector from player to hook
	#var length := player2hook.length()
	#if hookpoint_get:
		## if we more than 4 away from line, don't dampen speed as much
		#if length > 4:
			#velocity *= .999
		## Otherwise dampen speed more
		#else:
			#velocity *= .9
		#
		## Hook's law equation
		#var force := grapple_speed * (length - rest_length)
		#
		## Clamp force to be less than max_grapple_speed
		#if abs(force) > max_grapple_speed:
			#force = max_grapple_speed
		#
		## Preserve direction, but scale by force
		#velocity += player2hook.normalized() * force
	#
	#return length
#

#MAIN FUNCTIONS ------------------------------------------------------------------

func _ready() -> void:
	#if !is_on_floor():
		#position = Vector3(randi(), 0, randi())
	pass
func update_player_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)



func _physics_process(delta: float) -> void:
	#grapple()
	var floor_angle = get_floor_angle()
	#grapple_raycast_hit = camera_cast.get_collider()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized())
	var target_speed : Vector3 = direction * SPEED
	var speed_difference : Vector3 = target_speed - velocity
	speed_difference.y = 0
	if input_dir:
		current_acc_rate = Vector3(current_lerp_acc, 0, current_lerp_acc)
	else:
		current_acc_rate = Vector3(current_lerp_dec, 0, current_lerp_dec)
	var movement = speed_difference * current_acc_rate
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or hookpoint_get == true:
			velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("Sprint") and not sliding:
		SPEED = sprinting_speed_modifier
	if Input.is_action_just_released("Sprint") and not sliding:
		SPEED = walking_speed_modifier
	#self.state_chart.set_expression_property("Looking At: ", self.grapple_raycast.current_object)
	#if current_movement == movement_states.SLIDING:
		#velocity = velocity + (movement) * delta * SLIDE_DAMPEN_RATE
		#velocity = velocity + current_slide_vector * delta * (current_slide_time) * (-(current_slide_vector.y) + 0.01)
	#else:
		#velocity = velocity + (movement) * delta
	input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	#var direction: Vector3 = (neck.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * SPEED, ACCELERATION)


		#if current_movement == movement_states.SLIDING:
			#velocity.x = direction.x * slide_timer * slide_speed
			#velocity.z = direction.z * slide_timer * slide_speed
		#if current_movement == movement_states.SPRINTING:
			#velocity.x = direction.x * sprinting_speed_modifier
			#velocity.z = direction.z * sprinting_speed_modifier


	else:
		velocity.x = move_toward(velocity.x, 0, DECCELERATION)
		velocity.z = move_toward(velocity.z, 0, DECCELERATION)


	if falling and is_on_floor() and sliding:
		print("Impossible")
		slide_speed += fall_distance / 10
	fall_distance = -current_gravity.y


	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#if collision.get_collider().dot(Vector3.UP) < 0.5:
			#on_steep = true
			#break
		
	
	if (target_speed.x != 0 && abs(velocity.x) >= abs(target_speed.x) && sign(velocity.x) == sign(target_speed.x)):
		target_speed.x = lerp(velocity.x, target_speed.x, 1 - TARGET_LERP)
	else:
		target_speed.x = lerp(velocity.x, target_speed.x, TARGET_LERP)

	if (target_speed.z != 0 && abs(velocity.z) >= abs(target_speed.z) && sign(velocity.z) == sign(target_speed.z)):
		target_speed.z = lerp(velocity.z, target_speed.z, 1 - TARGET_LERP)
	else:
		target_speed.x = lerp(velocity.z, target_speed.z, TARGET_LERP)
	
	if Input.is_action_pressed("Crouch"):
		#if current_movement == movement_states.SPRINTING and slide_timer > 0.2:
		if Input.is_action_pressed("Sprint"):
			crouching = false
			can_slide = true

			if is_on_floor() and Input.is_action_pressed("Forward") and can_slide:
				state_chart.send_event("onSliding")
				slide(delta)
			#crouching = false
			#slide_timer = slide_timer_max
			#current_slide_vector = input_dir
			#print("Slide Began")
			#
			#current_movement = movement_states.SLIDING
			#current_slide_time = SLIDE_TIME_MAX
			#current_slide_vector = abs(velocity) * direction
			#current_slide_vector.y = 0
		else:
			crouching = true
			#current_posture = posture_states.STANDING
			#
	#if current_movement == movement_states.SLIDING:
		#state_chart.send_event("onSliding")
		#state_chart.send_event("onSlidingP")
		#current_posture = posture_states.SLIDING
	#if current_posture == posture_states.STANDING:
		#state_chart.send_event("onStanding")
	#if current_posture == posture_states.SLIDING:
		#state_chart.send_event("onSlidingP")
	if Input.is_action_just_released("Crouch"):
		can_slide = false
		sliding = false
	# Add the gravity.
	if not is_on_floor():
		falling = true
		velocity += get_gravity() * delta
	else:
		falling = false

	if is_on_floor() && floor_angle > SLOPE_SLIDE_THRESHOLD:
		var plane = Plane(get_floor_normal())
		movement = plane.project(movement)
		slide_timer += delta * 10
		#current_slide_vector = plane.project(current_slide_vector)

	# Handle jump.
	#if current_movement == movement_states.SLIDING:
		#slide_timer -= delta
		#if slide_timer <= 0.2:
			#current_movement = movement_states.WALKING
			#current_posture = posture_states.STANDING
			#print("Slide End")
	if velocity.y < 0:
		current_gravity.y = gravity_falling
	else:
		current_gravity.y = gravity_default
	#if current_movement == movement_states.SLIDING:
		#direction = (transform.basis * Vector3(current_slide_vector.x, 0, current_slide_vector.y )).normalized()
	
	if sliding == true:
		ACCELERATION = 1
	
	floor_snap_length = 0.5
	move_and_slide()
	

func _on_hook_attached(area: Area3D) -> void:
	is_hooked = true


func _on_hook_free(body: Node3D) -> void:
	is_hooked = false


func stand_up() -> void:
	SPEED = walking_speed_modifier
	Standing.disabled = false
	Crouching.disabled = true


func crouch() -> void:
	SPEED = crouching_speed_modifier
	Crouching.disabled = false
	Standing.disabled = true

func slide(delta : float) -> void:
	#state_chart.send_event("onCrouching")
	camera_controller.update_camera_pos(delta, -1)
	if not sliding:
		if slide_check.is_colliding() or get_floor_angle() < 0.2:
			slide_speed = 20
			slide_speed += fall_distance / 10
		else:
			print("yabadabadoo")
			slide_speed = 2
	sliding = true
	
	if slide_check.is_colliding():
		slide_speed += get_floor_angle() / 10
	else:
		slide_speed -= (get_floor_angle() / 5) + 0.03
	
	if slide_speed < 0:
		slide_speed = 0
		can_slide = false
		sliding = false
	SPEED = slide_speed
	Crouching.disabled = true
	Standing.disabled = false


func pull_player():
	pass

func update_gravity(delta) -> void:
	velocity.y -= gravity_default * delta

func update_input():
	pass

func update_velocity() -> void:
	move_and_slide()
