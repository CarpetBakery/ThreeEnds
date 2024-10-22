class_name PlayerFps extends CharacterBody3D

# Player options
# TODO: these do nothing
@export_group("Control flags")
@export var canSprint: bool = true
@export var canCrouch: bool = true
@export var canSlide: bool = true
@export var canFreelook: bool = true

# Speed vars
var currentSpd: float = 5.0
@export_group("Movement Speeds")
@export var walkSpd: float = 5.0
@export var sprintSpd: float = 8.0
@export var crouchSpd: float = 3.0

# Mouse look sensitivity
# NOTE: The sensitivity seems to change based on how big you set the viewport... wtf...
@export_group("Mouse sensitivity")
@export var mouseSens: float = 0.17

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
@export_group("Headbobbing")
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
@export_group("Fov")
@export var targetFov: float = 80.0
@export var walkFov: float = 80.0
@export var sprintFov: float = 85.0


# -- Nodes --
@export_group("Components")
@export var neck: Node3D
@export var head: Node3D
@export var eyes: Node3D
@export var camera: Camera3D

# Collision nodes
@export var standing_collision_shape: CollisionShape3D
@export var crouching_collision_shape: CollisionShape3D
@export var ray_cast_3d: RayCast3D

# Interaction nodes
@export var rayCastInteract: RayCast3D
# Reference to interaction text label
var interactionText: Label 

# HUD nodes
@export var hud: Control
@export var screenSurface: TextureRect

# Audio nodes
@export var footstepSpeaker: AudioStreamPlayer


# -- Interaction system --
# List of nodes that were previously in focus
var focusedInteractables: Array[Interactable] = []


# -- Movement --
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
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Setup the hud
	_setupHud()

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
		var signBefore = sign(headBobVec.y)
		
		headBobVec.y = sin(headBobIndex)
		headBobVec.x = sin(headBobIndex/2) + 0.5
		eyes.position.y = lerp(eyes.position.y,  headBobVec.y * (headBobCurrentIntensity / 2.0), delta * lerpSpd)
		
		# Handle footstep sounds
		if signBefore == 1 and sign(headBobVec.y) != signBefore:
			_playFootstep()
		
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
	
	# -- Process interaction --
	interactionText.text = ""
	_processInteraction(delta)
	

func _processInteraction(delta):
	# Get the currently colliding area and run onInteract
	# NOTE: This currently only works for one object at a time...
	# if we're colliding with more than one thing this might explode
	
	if rayCastInteract.is_colliding():
		var node = rayCastInteract.get_collider()
		
		if node is Interactable:
			if node not in focusedInteractables:
				# Add node to focused array and call inFocus
				node.enterFocus(self)
				node.focused = true
				focusedInteractables.insert(0, node)
			#else:
				## Currently colliding node *is* in the list already. Move it to the front
				#var ind: int = focusedInteractables.find(node)
				## Only move if this node isn't already at the front
				#if ind != 0:
					#focusedInteractables.remove_at(ind)
					#focusedInteractables.insert(0, node)
			
			# This should NEVER happen
			if focusedInteractables.is_empty():
				print("Error: Interactable list is empty")
				return
			
			# Temp var for convenience
			var currentNode: Interactable = focusedInteractables[0]
			# Call inFocus on Interactable
			currentNode.inFocus(self)
			
			# Interact with the object if 'interact' button is pressed
			if Input.is_action_just_pressed("interact"):
				currentNode.onInteract(self)
	else:
		# We aren't colliding with anything anymore, just clear focused list 
		_clearFocused()

func _clearFocused():
	# Call exit focus on each node
	for i in focusedInteractables:
		i.focused = false
		i.exitFocus(self)
	# Clear focused array
	focusedInteractables.clear()

## Set up the HUD
func _setupHud():
	# Setup references
	interactionText = hud.getInteractionText()
	
	# Make sure the main surfaces are visible
	screenSurface.show()

## Play footstep sound
func _playFootstep():
	## TODO: Determine what material the ground is and play a sound
	#footstepSpeaker.pitch_scale = randf_range(0.8, 1.2)
	#footstepSpeaker.play()
	pass

## Set the interaction text 
func setInteractionText(string: String):
	interactionText.text = string
