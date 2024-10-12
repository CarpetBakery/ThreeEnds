class_name DialogManager extends Node

# Components
@onready var dialogLabel: Label = $Label
@onready var dialogBox: ColorRect = $ColorRect
@onready var speaker: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Export vars
@export var speed : float = 10

var delay : float = 0

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
	while true:
		# Add a letter to the end
		dialogLabel.visible_characters += 1
		
		# Play sound
		#speaker.play()
		
		# Exit if we're finshed printing the string
		if dialogLabel.visible_ratio >= 1:
			break
		
		await get_tree().create_timer(speed, false).timeout
