class_name ComputerManager extends Node

# Nodes
@export var cursor: Sprite2D
@export var viewport: SubViewport
@export var cam: Camera2D

func _ready() -> void:
	# Hide the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func _process(delta: float) -> void:
	# Set the cursor to the mouse position
	#cursor.position = get_viewport().get_mouse_position()
	#cursor.position = viewport.get_mouse_position()
	#cursor.position = cam.get_local_mouse_position()
	#print(cam.get_local_mouse_position())
	print(viewport.get_mouse_position())
	cursor.position = floor(viewport.get_mouse_position())
	
	if Global.DEBUG_MODE:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
