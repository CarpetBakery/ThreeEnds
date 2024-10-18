class_name ComputerManager extends Node

# Nodes
@export var viewport: SubViewport
@export var cam: Camera2D

# Nodes in this scene
@export_category("Essential nodes")
@export var cursor: Sprite2D
@export var cursorArea: Area2D
@export var emailWindow: ComputerWindow

@export_category("Clickables")
@export var emailIcon: Sprite2D
@export var emailIconArea: Area2D

# Audio nodes
@export var click: AudioStreamPlayer
@export var release: AudioStreamPlayer



func _ready() -> void:
	#Engine.max_fps = 50
	
	# Hide the native mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Hide windows
	emailWindow.hide()

func _process(delta: float) -> void:
	# Set the cursor to the mouse position
	cursor.position = floor(viewport.get_mouse_position())
	# Clamp cursor position inside screen
	cursor.position.x = clamp(cursor.position.x, 0, 640-1)
	cursor.position.y = clamp(cursor.position.y, 0, 480-1)
	
	# Check for mouse collision on click
	var sndOffset = 0.0025;
	if Input.is_action_just_pressed("mouseLeft"):
		# Play click sound
		click.pitch_scale = randf_range(0.95, 1.05)
		click.play(randf_range(0, sndOffset))
		
		for i in cursorArea.get_overlapping_areas():
			if i == emailIconArea:
				emailWindow.showWindow()
	
	if Input.is_action_just_released("mouseLeft"):
		# Play release sound
		release.pitch_scale = randf_range(0.95, 1.05)
		release.play(randf_range(0, sndOffset))
	
	# Quit game in debug mode
	if Global.DEBUG_MODE:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
