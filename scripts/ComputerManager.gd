class_name ComputerManager extends Node

# Nodes
@onready var cursor: Sprite2D = $Control/cursor

func _ready() -> void:
	# Hide the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func _process(delta: float) -> void:
	# Set the cursor to the mouse position
	cursor.position = get_viewport().get_mouse_position()
