class_name DialogManager extends Node

# Components
@onready var dialogLabel: Label = $Label
@onready var dialogBox: ColorRect = $ColorRect
@onready var speaker: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Export vars
@export var speed : float = 0.02

var delay : float = 0		## For pausing text
var printing: bool = false	## Are we currently printing?

func _ready() -> void:
	# Don't show any characters
	dialogLabel.visible_characters = 0
	printText()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		hideText()
		printText()

func hideText():
	dialogLabel.visible_characters = 0

func printText():
	# Don't try to start printing again if we're already doing it
	if printing:
		return
	
	printing = true
	while printing:
		# Add a letter to the end
		dialogLabel.visible_characters += 1
		
		# Play sound
		#speaker.play()
		
		# Exit if we're finshed printing the string
		if dialogLabel.visible_ratio >= 1:
			printing = false
			break
		await get_tree().create_timer(speed, false).timeout
	print_debug("Finshed printing")
