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
@export var notifSound: AudioStreamPlayer
@export var pcOn: AudioStreamPlayer
@export var pcOff: AudioStreamPlayer
@export var windowsClick: AudioStreamPlayer

@export_category("Other UI")
@export var animPlayer: AnimationPlayer
@export var notifAnimPlayer: AnimationPlayer
@export var getUpLabelAnim: AnimationPlayer
var getUpAppearTimer: Timer = Timer.new()
@export var black: ColorRect
@export var uiParent: Control
@export var getUpLabel: Label

# -- Intro --
@export_category("Intro")
@export var introText: Label


# -- Scene flow --
## Whether or not the player can interact with the computer
var canInteract: bool = true
## Can interact with the email icon
var canInteractEmail: bool = false
## Can we get up?
var canGetUp: bool = false
var timeTilGetUp: float = 4

## Skip intro
var skipIntro: bool = false

func _ready() -> void:
	# -- Do intro --
	# Hide the native mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Attach timer
	add_child(getUpAppearTimer)
	getUpAppearTimer.one_shot = true
	getUpAppearTimer.timeout.connect(_showGetUpText)
	
	# Hide windows
	emailWindow.hide()
	
	uiParent.show()
	black.hide()
	notifIcon.hide()
	getUpLabel.hide()
	
	if skipIntro and Global.DEBUG_MODE:
		finishIntro()
	else:
		# Play intro animation
		canInteract = false
		animPlayer.play("intro")


func finishIntro():
	# Hide intro text
	introText.hide()
	introText.text = ""
	
	# Allow the player to interact
	canInteract = true
	
	# Wait 4 seconds
	await get_tree().create_timer(4).timeout
	
	# Email notification
	canInteractEmail = true
	notifAnimPlayer.play("blink")
	notifSound.play()


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
			# Click on email icon
			if i == emailIconArea and canInteractEmail:
				# Stop playing animation 
				if notifAnimPlayer.is_playing():
					notifAnimPlayer.play("RESET")
					getUpAppearTimer.start(timeTilGetUp)
				
				windowsClick.play()
				emailWindow.showWindow()
	
	if Input.is_action_just_released("mouseLeft"):
		# Play release sound
		release.pitch_scale = randf_range(0.95, 1.05)
		release.play(randf_range(0, sndOffset))
	
	# Get up from the desk
	if Input.is_action_just_pressed("interact"):
		if canGetUp:
			pcOff.play()
			getUp()


func _showGetUpText() -> void:
	print("Played")
	getUpLabelAnim.play("appear")
	canGetUp = true
	
	await get_tree().create_timer(0.05).timeout
	getUpLabel.show()
	


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


func playAmbience():
	computerAmbience.play()
