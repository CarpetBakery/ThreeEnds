class_name PlayerFps extends CharacterBody3D

# Player options
@export_group("Control flags")
@export var canJump: bool = true
@export var canSprint: bool = true
@export var canCrouch: bool = true
@export var canSlide: bool = false
@export var canFreelook: bool = false
@export var freezeMovement: bool = false

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

# Carrying
@export var carrySocket: Node3D
@export var carryBarrel: MeshInstance3D

# HUD nodes
@export var hud: PlayerHud
@export var screenSurface: TextureRect
var interactionText: Label 
var dialogText: Label
var progressBar: ProgressBar

# Audio nodes
@export var footstepSpeaker: AudioStreamPlayer
@export var dialogSpeaker: AudioStreamPlayer

# -- Input vars --
var interactPressed: bool = false
var interactHeld: bool = false


# -- Interaction system --
# Whether or not the player can interact with stuff
var canInteract: bool = true
# List of nodes that were previously in focus
var focusedInteractables: Array[Interactable] = []

# Signal triggered when the player closes a dialog box
signal dialogFinished

# -- Carrying objects --
## Types of objects that we can carry
enum CarryType {
	NONE,
	BARREL
}
# Current object that we're carrying
var carryObject := CarryType.NONE

# -- Movement --
var lerpSpd: float = 10.0
var airLerpSpd: float = 3.0
var direction: Vector3 = Vector3.ZERO

# How much lower the camera will be relative to walking
const playerHeight: float = 1.8
const crouchingHeight: float = -0.8

# Whether or not to capture mouse
var captureMouse: bool = true;

# -- Dialog system --
# Array of strings to display
var msg: Array[String]
# Is the player in a dialog window?
var inDialog: bool = false
# Timer for drawing text
var dialogTimer: Timer = Timer.new()
# How quickly the dialog displays
var dialogSpd: float = 0.02


# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const gravity: float = 9.9 * 1.6

func _ready():
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Setup the hud
	_setupHud()

	# Dialog setup
	add_child(dialogTimer)
	dialogTimer.one_shot = true
	dialogTimer.timeout.connect(_dialogTypeChar)
	
	# -- Setup interaction and carrying --
	# Hide barrel mesh
	carryBarrel.hide()
	
	# If previous scene was a transition, handle that
	if Global.transition:
		Global.transition = false

func _input(event):
	# Look around using the mouse
	if event is InputEventMouseMotion and captureMouse and not freezeMovement:
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
				# Allow game to quit if escape is pressed again
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
	# If we're in a dialog window, don't get any input
	if inDialog:
		freezeMovement = true
	
	# Get input vars
	interactPressed = Input.is_action_just_pressed("interact")
	interactHeld = Input.is_action_pressed("interact")
	
	# Get movement inputs
	var inputDir: Vector2
	if not freezeMovement:
		inputDir = Input.get_vector("left", "right", "forward", "backward")
	
	# Crouching and sprinting
	if (Input.is_action_pressed("crouch") || sliding) and canCrouch:
		# Set head position
		head.position.y = lerp(head.position.y, crouchingHeight, delta * lerpSpd)
		
		# Set collision shape
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		# Change to crouching speed
		currentSpd = lerp(currentSpd, crouchSpd, delta * lerpSpd)
		
		# Slide begin logic
		if sprinting && inputDir != Vector2.ZERO and canSlide:
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
		
		if Input.is_action_pressed("sprint") and canSprint and inputDir != Vector2.ZERO:
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
	if (Input.is_action_pressed("free_look") || sliding):
		freeLooking = true
		if !sliding:
			eyes.rotation.z = deg_to_rad(neck.rotation.y * freeLookTiltAmt)
			if !canFreelook:
				freeLooking = false
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
	if canJump and Input.is_action_just_pressed("ui_accept") and is_on_floor():
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
	var eyePos: Vector3 = neck.position + head.position + eyes.position
	var eyeRot: Vector3 = neck.rotation + head.rotation + eyes.rotation
	camera.position = position + eyePos
	camera.rotation = rotation + eyeRot
	
	# Lerp carrySocket for smooth movement
	var carryLerpSpd = 0.4
	carrySocket.position = position + eyePos
	#carrySocket.position = lerp(carrySocket.position, position + eyePos, carryLerpSpd)
	carrySocket.rotation.x = lerp_angle(carrySocket.rotation.x, rotation.x + eyeRot.x, carryLerpSpd)
	carrySocket.rotation.y = lerp_angle(carrySocket.rotation.y, rotation.y + eyeRot.y, carryLerpSpd)
	carrySocket.rotation.z = lerp_angle(carrySocket.rotation.z, rotation.z + eyeRot.z, carryLerpSpd)
	
	# -- Process interaction --
	if not inDialog:
		# Reset interaction text
		interactionText.text = ""
		# Hide progressbar
		progressBar.hide()
		
		_processInteraction(delta)
		_processCarry(delta)
	else:
		_processDialog(delta)
	

func _processInteraction(delta):
	# Get the currently colliding area and run onInteract
	# NOTE: This currently only works for one object at a time...
	# if we're colliding with more than one thing this might explode
	
	if !canInteract:
		_clearFocused()
		return
	
	if rayCastInteract.is_colliding():
		var node = rayCastInteract.get_collider()
		
		if node is Interactable:
			if node not in focusedInteractables:
				# Add node to focused array and call inFocus
				if  node.canFocus:
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
			if currentNode.canFocus:
				currentNode.inFocus(self)
			
			# Interact with the object if 'interact' button is pressed
			if interactPressed and currentNode.canInteract:
				interactPressed = false
				currentNode.onInteract(self)
	else:
		# We aren't colliding with anything anymore, just clear focused list 
		_clearFocused()


func _processCarry(_delta):
	# Don't do anything for now
	return
	
	match carryObject:
		CarryType.BARREL:
			if interactPressed:
				interactPressed = false
				dropObject()


## Clear focused interactables array
func _clearFocused():
	# Call exit focus on each node
	for i in focusedInteractables:
		if i.canFocus:
			i.focused = false
			i.exitFocus(self)
	# Clear focused array
	focusedInteractables.clear()


func pickupObject(type: CarryType):
	# Set carry type
	carryObject = type
	
	match carryObject:
		CarryType.BARREL:
			carryBarrel.show()
	

func dropObject():
	## NOTE: Might not even both using this function...
	match carryObject:
		CarryType.BARREL:
			carryBarrel.hide()
	
	# Reset carry type
	carryObject = CarryType.NONE


# -- Hud functions --
## Set up the HUD
func _setupHud():
	# Setup references
	interactionText = hud.interactionText
	progressBar = hud.progressBar
	# Dialog
	dialogText = hud.dialogText
	
	# Make sure the main surfaces are visible
	screenSurface.show()

## Set the interaction text 
func setInteractionText(string: String) -> void:
	interactionText.text = string

## Return the hud component
func getHud() -> PlayerHud:
	return hud


# - Dialog -
func _processDialog(_delta: float) -> void:
	# Handle interaction button input
	if interactPressed:
		if dialogText.visible_ratio < 1:
			# Pressed while dialog is still typing- display all of it 
			dialogTimer.stop()
			dialogText.visible_characters = dialogText.get_total_character_count()
		else:
			# Pressed while dialog is finished drawing- go to next string
			_nextDialogString()
		
		# Clear input var
		interactPressed = false


## Type a single character in the current dialog string
func _dialogTypeChar() -> void:
	# How frequently to play the dialog noises
	var playFreq = 2
	
	if dialogText.visible_ratio < 1:
		dialogText.visible_characters += 1
		
		# Play audio
		if dialogText.visible_characters % playFreq == 0:
			var sndOffset = randf_range(0, 0.0025 * 40) * 1.5
			var sndOffsetMax = 0.0025 * 40 * 1.5
			
			dialogSpeaker.pitch_scale = randf_range(0.96, 1.04) * 1.3 
			#dialogSpeaker.volume_db = randf_range(-10, -2) * sndOffset * 40
			dialogSpeaker.volume_db = ((sndOffsetMax - sndOffset) * 40) * 0.3
			dialogSpeaker.play(sndOffset)
		
		# Restart the timer
		#dialogTimer.start(dialogSpd * randf_range(0.1, 2.3) * get_process_delta_time() / 0.01666)
		dialogTimer.start(dialogSpd * randf_range(0.1, 2.3) * 0.95)
	else:
		dialogTimer.stop()


## Start the dialog
func startDialog() -> void:
	if len(msg) <= 0:
		# There are no messages to show
		return
	
	# Freeze player
	inDialog = true
	freezeMovement = true

	# Show dialog UI
	dialogText.show()
	hud.toggleCinemaBars(true)
	
	# Reset interaction text
	interactionText.text = ""
	
	if hud.playAnimations:
		# Play animation
		hud.animationPlayer.play("barsIn")
		var scaleBefore = hud.animationPlayer.speed_scale
		hud.animationPlayer.speed_scale = 5
		await hud.animationPlayer.animation_finished
		hud.animationPlayer.speed_scale = scaleBefore
	
	# Set text to first message
	dialogText.text = msg.front()
	dialogText.visible_characters = 0

	# Kick off dialog drawing
	_dialogTypeChar()


## Close the dialog window
func closeDialog() -> void:
	# Clean up text and msg array
	msg.clear()
	dialogText.visible_characters = 0

	# Unfreeze player
	inDialog = false
	freezeMovement = false
	
	# Hide dialog UI
	dialogText.hide()
	
	if hud.playAnimations:
		# Play animation
		hud.animationPlayer.play("barsOut")
		var scaleBefore = hud.animationPlayer.speed_scale
		hud.animationPlayer.speed_scale = 5
		await hud.animationPlayer.animation_finished
		hud.animationPlayer.speed_scale = scaleBefore
	
	hud.toggleCinemaBars(false)
	
	# Emit signal
	dialogFinished.emit()
	


## Add dialog string
func addDialog(string: String) -> void:
	msg.push_back(string)


## Move to the next dialog string
func _nextDialogString() -> void:
	if len(msg) > 1:
		# Pop message off the front
		msg.pop_front()
		# Reset text for next string
		dialogText.visible_characters = 0
		dialogText.text = msg.front()
		
		# Kickstart drawing process
		_dialogTypeChar()
	else:
		# That was the last message; close dialog box		
		closeDialog()


# -- Audio --
## Play footstep sound
func _playFootstep() -> void:
	## TODO: Determine what material the ground is and play a sound
	#footstepSpeaker.pitch_scale = randf_range(0.8, 1.2)
	#footstepSpeaker.play()
	pass
