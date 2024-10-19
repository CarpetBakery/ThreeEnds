# Class definition can be done like this
class_name PlayerFpsOld
# This class inherits from CharacterBody3D
extends CharacterBody3D

var speed
const WALK_SPEED = 7.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.006

# Head bobbing
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Look with mouse
		head.rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		
		# Clamp vertical rotation
		const VIEW_ANGLE = 90
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-VIEW_ANGLE), deg_to_rad(VIEW_ANGLE))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 20.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 20.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 12.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 12.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
		
	# Head bobbing
	t_bob += delta * velocity.length() * float(is_on_floor())
	#camera.transform.origin = headBob(t_bob)

	move_and_slide()

func headBob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP /2
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
