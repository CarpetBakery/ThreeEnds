extends CharacterBody3D

# Nodes
@onready var neck: Node3D = $Neck
@onready var head: Node3D = $Neck/head
@onready var eyes: Node3D = $Neck/head/Eyes
@onready var camera: Camera3D = $HUD/SubViewport/camera

@onready var standing_collision_shape = $standingCollisionShape
@onready var crouching_collision_shape = $crouchingCollisionShape
@onready var ray_cast_3d = $RayCast3D

# Player options
# TODO: these do nothing
@export var canSprint: bool = true
@export var canCrouch: bool = true
@export var canSlide: bool = true
@export var canFreelook: bool = true

# Speed vars
var currentSpd: float = 5.0
@export_category("Movement Speeds")
@export var walkSpd: float = 5.0
@export var sprintSpd: float = 8.0
@export var crouchSpd: float = 3.0

# States
var walking: bool = false
var sprinting: bool = false
var crouching: bool = false
var freeLooking: bool = false
var sliding: bool = false

# Slide vars
var slideTimer: float = 0.0
var slideTimerMax: float = 1.0 # 1 second long slide
var slideVec: Vector2 = Vector2.ZERO
var slideSpd: float = 10.0

# Headbobbing vars
@export_category("Headbobbing")
@export var headBobWalkSpd: float = 14.0
@export var headBobSprintSpd: float = 18.0
@export var headBobCrouchSpd: float = 10.0

@export var headBobWalkIntensity: float = 0.1
@export var headBobSprintIntensity: float = 0.2
@export var headBobCrouchIntensity: float = 0.05

var headBobVec: Vector2 = Vector2.ZERO
var headBobIndex: float = 0.0 
var headBobCurrentIntensity: float = 0.0

# Movement vars
const jumpVelocity = 4.5 * 1.4
var freeLookTiltAmt: float = -8.0
var freeLookRange: float = deg_to_rad(80.0)

# Fov values
@export_category("Fov")
@export var targetFov: float = 80.0
@export var walkFov: float = 80.0
@export var sprintFov: float = 85.0

# Mouse look sensitivity
# NOTE: The sensitivity seems to change based on how big you set the viewport... wtf...
const mouseSens = 0.17

var lerpSpd: float = 10.0
var airLerpSpd: float = 3.0

var direction: Vector3 = Vector3.ZERO

# How much lower the camera will be relative to walking
const playerHeight: float = 1.8
const crouchingHeight: float = -0.8

# Whether or not to capture mouse
var captureMouse: bool = true;

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const gravity: float = 9.9 * 1.6

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Look around using the mouse
	if event is InputEventMouseMotion and captureMouse:
		# Make sure to take screen scale into account
		var viewportBaseSize: Vector2 = get_viewport().size
		var viewportOverrideSize: Vector2 = get_tree().root.content_scale_size
		var scaleFac: Vector2 = viewportBaseSize / viewportOverrideSize
		
		# Rotate neck instead of head
		if freeLooking:
			neck.rotate_y(-deg_to_rad(event.relative.x * mouseSens * scaleFac.x))
			neck.rotation.y = clamp(neck.rotation.y, -freeLookRange, freeLookRange)
		else:
			rotate_y(-deg_to_rad(event.relative.x * mouseSens * scaleFac.x))
			
		head.rotate_x(-deg_to_rad((event.relative.y * mouseSens * scaleFac.y)))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Free mouse
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			if captureMouse:
				# ALlow game to quit if escape is pressed again
				captureMouse = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				get_tree().quit()
	# Capture mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !captureMouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			captureMouse = true


func _physics_process(delta):
	# Get movement inputs
	var inputDir = Input.get_vector("left", "right", "forward", "backward")
	
	# Crouching and sprinting
	if Input.is_action_pressed("crouch") || sliding:
		# Set head position
		head.position.y = lerp(head.position.y, crouchingHeight, delta * lerpSpd)
		
		# Set collision shape
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		# Change to crouching speed
		currentSpd = lerp(currentSpd, crouchSpd, delta * lerpSpd)
		
		# Slide begin logic
		if sprinting && inputDir != Vector2.ZERO:
			sliding = true
			freeLooking = true
			slideTimer = slideTimerMax
			slideVec = inputDir
		
		walking = false
		sprinting = false
		crouching = true
		
	elif !ray_cast_3d.is_colliding():
		# Set collision shape
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		
		# Reset head position
		head.position.y = lerp(head.position.y, 0.0, delta * lerpSpd)
		
		if Input.is_action_pressed("sprint"):
			# Sprinting
			currentSpd = lerp(currentSpd, sprintSpd, delta * lerpSpd)
			
			walking = false
			sprinting = true
			crouching = false
		else:
			# Walking
			currentSpd = lerp(currentSpd, walkSpd, delta * lerpSpd)
			
			walking = true
			sprinting = false
			crouching = false
	
	# Handle free looking
	if Input.is_action_pressed("free_look") || sliding:
		freeLooking = true
		if !sliding:
			eyes.rotation.z = deg_to_rad(neck.rotation.y * freeLookTiltAmt)
	else:
		# Reset the rotation of the eyes and neck with easing
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerpSpd)
		eyes.rotation.z = lerp(eyes.rotation.z, 0.0, delta * lerpSpd)
		freeLooking = false
		
	# Slide end logic
	if sliding:
		slideTimer -= delta
		if slideTimer <= 0:
			sliding = false
			freeLooking = false
			
	# Handle headbob
	if sprinting:
		headBobCurrentIntensity = headBobSprintIntensity
		headBobIndex += headBobSprintSpd * delta
		targetFov = sprintFov
	elif walking:
		headBobCurrentIntensity = headBobWalkIntensity
		headBobIndex += headBobWalkSpd * delta
		targetFov = walkFov
	elif crouching:
		headBobCurrentIntensity = headBobCrouchIntensity
		headBobIndex += headBobCrouchSpd * delta
		targetFov = walkFov
		
	if is_on_floor() && !sliding && inputDir != Vector2.ZERO:
		headBobVec.y = sin(headBobIndex)
		headBobVec.x = sin(headBobIndex/2) + 0.5
		eyes.position.y = lerp(eyes.position.y,  headBobVec.y * (headBobCurrentIntensity / 2.0), delta * lerpSpd)
		
	else:
		eyes.position.y = lerp(eyes.position.y,  0.0, delta * lerpSpd)
		eyes.position.x = lerp(eyes.position.x,  0.0, delta * lerpSpd)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity
		sliding = false

	# Get the input direction and handle the movement/deceleration.
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(inputDir.x, 0, inputDir.y)).normalized(), delta * lerpSpd)
	else:
		if inputDir != Vector2.ZERO:
			direction = lerp(direction, (transform.basis * Vector3(inputDir.x, 0, inputDir.y)).normalized(), delta * airLerpSpd)
	
	if sliding:
		direction = (transform.basis * Vector3(slideVec.x, 0, slideVec.y)).normalized()
		currentSpd = (slideTimer + 0.1) * slideSpd
	
	if direction:
		velocity.x = direction.x * currentSpd
		velocity.z = direction.z * currentSpd
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpd)
		velocity.z = move_toward(velocity.z, 0, currentSpd)
	
	camera.fov = lerp(camera.fov, targetFov, delta * lerpSpd)
	
	move_and_slide()
	
	# Move the camera to be at the correct position and rotation
	camera.position = position + neck.position + head.position + eyes.position
	camera.rotation = rotation + neck.rotation + head.rotation + eyes.rotation
	
