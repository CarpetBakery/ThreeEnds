class_name ComputerManager extends Node

# Nodes
@export var viewport: SubViewport
@export var cam: Camera2D

# Nodes in this scene
@onready var cursor: Sprite2D = $cursor


func _ready() -> void:
	#Engine.max_fps = 50
	
	# Hide the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	# Set the cursor to the mouse position
	cursor.position = floor(viewport.get_mouse_position())
	# Clamp cursor position inside screen
	cursor.position.x = clamp(cursor.position.x, 0, 640-1)
	cursor.position.y = clamp(cursor.position.y, 0, 480-1)
	
	if Global.DEBUG_MODE:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
