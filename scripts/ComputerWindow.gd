class_name ComputerWindow extends Sprite2D

@export var dragBox: CollisionShape2D

# Dragging
var mouseOnDrag: bool = false
var dragging: bool = false
var mouseStartPos: Vector2

# Texture size
var texSize: Vector2

# Viewport size
var viewSize = Vector2(853, 480)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texSize = texture.get_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouseLeft"):
		if mouseOnDrag:
			dragging = true
			mouseStartPos = position - get_viewport().get_mouse_position()
	
	if not Input.is_action_pressed("mouseLeft"):
		dragging = false
	
	# Dragging behaviour
	if dragging:
		position = mouseStartPos + get_viewport().get_mouse_position()
		print(position)
	else:
		# Snap back to the inside of the screen
		var xpad = (viewSize.x - 640) / 2
		position.x = clamp(position.x, xpad + texSize.x/2, viewSize.x - xpad - texSize.x/2)
		position.y = clamp(position.y, texSize.y/2, viewSize.y - texSize.y/2)
		#position.y = clamp(position.y, texSize.y/2, viewSize.y - texSize.y)
		pass


func _on_area_2d_mouse_entered() -> void:
	mouseOnDrag = true


func _on_area_2d_mouse_exited() -> void:
	mouseOnDrag = false
