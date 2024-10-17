class_name ComputerWindow extends Sprite2D

@export var cursorArea: Area2D
@export var dragArea: Area2D
@export var closeArea: Area2D

@onready var whiteFlash: Sprite2D = $WhiteFlash

# Hovering on close
var mouseOnClose: bool = false

# Dragging
var mouseOnDrag: bool = false
var dragging: bool = false
var mouseStartPos: Vector2

# Texture size
var texSize: Vector2

# Viewport size
var viewSize: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texSize = texture.get_size()
	viewSize = get_viewport().size
	whiteFlash.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouseOnClose = false
	mouseOnDrag = false
	
	# Check mouse collisions
	for i in cursorArea.get_overlapping_areas():
		if i == dragArea:
			mouseOnDrag = true
		if i == closeArea:
			mouseOnClose = true
	
	if Input.is_action_just_pressed("mouseLeft"):
		if mouseOnDrag:
			dragging = true
			mouseStartPos = position - get_viewport().get_mouse_position()
		if mouseOnClose:
			hideWindow()
	
	if not Input.is_action_pressed("mouseLeft"):
		dragging = false
	
	# Dragging behaviour
	if dragging:
		position = mouseStartPos + get_viewport().get_mouse_position()
	else:
		# Snap back to the inside of the screen
		var xpad = (viewSize.x - 640) / 2
		xpad = 0
		position.x = clamp(position.x, xpad + texSize.x/2, viewSize.x - xpad - texSize.x/2)
		position.y = clamp(position.y, texSize.y/2, viewSize.y - texSize.y/2)
	
	if Input.is_action_just_pressed("jump"):
		showWindow()
	
	# Round position
	position = floor(position)

## Show the window
func showWindow():
	if visible:
		return
	
	show()
	whiteFlash.show()
	await get_tree().create_timer(0.2, false).timeout
	whiteFlash.hide()
	

## Hide the window
func hideWindow():
	if not visible:
		return
	
	whiteFlash.show()
	await get_tree().create_timer(0.08, false).timeout
	hide()
