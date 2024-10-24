class_name ComputerManager extends Node

# Nodes
@export_category("Assigned Outside")
@export var viewport: SubViewport
@export var cam: Camera2D

# Nodes in this scene
@export_category("Essential nodes")
@export var cursor: Sprite2D
@export var cursorArea: Area2D
@export var emailWindow: ComputerWindow
@export var notifIcon: Sprite2D

@export_category("Clickables")
@export var emailIcon: Sprite2D
@export var emailIconArea: Area2D

# Audio nodes
@export_category("Audio")
@export var click: AudioStreamPlayer
@export var release: AudioStreamPlayer
@export var computerAmbience: AudioStreamPlayer

@export_category("Other UI")
@export var animPlayer: AnimationPlayer
@export var black: ColorRect
@export var uiParent: Control

## Whether or not the player can interact with the computer
var canInteract: bool = true

## Skip intro
var skipIntro: bool = false

func _ready() -> void:
	# -- Do intro --
	canInteract = false
	
	# Hide the native mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Hide windows
	emailWindow.hide()
	
	# Show ui parent
	uiParent.show()
	# Hide black rectangle
	black.hide()
	# Hide notification
	notifIcon.hide()
	
	# Play intro animation
	animPlayer.play("intro")


func finishIntro():
	canInteract = true


func _process(delta: float) -> void:
	# Quit game in debug mode
	if Global.DEBUG_MODE:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
	
	if not canInteract:
		return
	
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
	
	# Get up from the desk
	if Input.is_action_just_pressed("interact"):
		getUp()


## Get up from the computer
func getUp() -> void:
	# TODO: Change master volume for this instaed, so the mouse clicks are also faded out
	
	# Stop player from interacting
	canInteract = false
	
	# Play fadeout animation
	animPlayer.play("fadeOut")
	black.color.a = 0
	black.show()
	# Wait till animation is done
	await animPlayer.animation_finished
	# Go to other scene
	get_tree().change_scene_to_file("res://maps/mpOilRigBlockout.tscn")
