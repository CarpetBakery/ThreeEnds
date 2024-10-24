class_name ComputerWindow extends Sprite2D

@export_category("Collision Areas")
@export var cursorArea: Area2D
@export var dragArea: Area2D
@export var closeArea: Area2D

@export_category("Nodes")
@export var parent: ComputerManager
@export var whiteFlash: Sprite2D
@export var scrollContainer: ScrollContainer

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
	
	# Don't do anything here if the window isn't visible
	if not visible or not parent.canInteract:
		return
	
	# Scroll container
	var scrollSpd = 40
	if Input.is_action_just_pressed("mouseWheelDown"):
		scrollContainer.scroll_vertical += scrollSpd
	if Input.is_action_just_pressed("mouseWheelUp"):
		scrollContainer.scroll_vertical -= scrollSpd
	
	# Check mouse collisions
	for i in cursorArea.get_overlapping_areas():
		if i == dragArea:
			mouseOnDrag = true
		if i == closeArea:
			mouseOnClose = true
	
	# Player pressed left click
	if Input.is_action_just_pressed("mouseLeft"):
		if mouseOnDrag:
			dragging = true
			mouseStartPos = position - get_viewport().get_mouse_position()
		if mouseOnClose:
			hideWindow()
	
	# Player released left click
	if not Input.is_action_pressed("mouseLeft"):
		dragging = false
	
	# -- Dragging behaviour --
	if dragging:
		position = mouseStartPos + get_viewport().get_mouse_position()
	else:
		# Snap back to the inside of the screen
		var xpad = (viewSize.x - 640) / 2
		xpad = 0
		position.x = clamp(position.x, xpad + texSize.x/2, viewSize.x - xpad - texSize.x/2)
		position.y = clamp(position.y, texSize.y/2, viewSize.y - texSize.y/2)
	
	# Round position
	position = floor(position)

## Show the window
func showWindow():
	if visible:
		return
	# Scroll back to the top
	scrollContainer.scroll_vertical = 0
	# Move to the center of the screen
	position = viewSize / 2
	position = floor(position)
	
	show()
	whiteFlash.show()
	await get_tree().create_timer(0.2, false).timeout
	whiteFlash.hide()
	

## Hide the window
func hideWindow():
	if not visible or whiteFlash.visible:
		return
	
	whiteFlash.show()
	await get_tree().create_timer(0.08, false).timeout
	hide()
