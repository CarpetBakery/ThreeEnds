class_name DialogManager extends Node

# Components
@onready var dialogLabel: Label = $Label
@onready var dialogBox: ColorRect = $ColorRect
@onready var speaker: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Export vars
@export var speed : float = 0.01		## Printing speed of the text
@export var sounds: Array[AudioStream]	## Array of sounds to play randomly

var entries: Array[DialogEntry]	## Entries of dialog
var delay : float = 0			## For pausing text
var printing: bool = false		## Are we currently printing?

func _ready() -> void:
	# Don't show any characters
	dialogLabel.visible_characters = 0
	
	# Add sounds to stream player
	speaker.stream = sounds[1]
	
	var de := DialogEntry.new()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		dialogLabel.text = "QJIQJTOIQJWOTIJQWOIJQWOTIJQ OWTIJQOWITJ QWIPTJIQJWT\nJQWUOIJQWOITJQWOITJQOWIJT\nYAAAAHAHAHAHAHAHHAH WHAT THE HELL!!!!!!!!!!!!!!!!!!!!"
		
		hideText()
		printText()

func hideText():
	dialogLabel.visible_characters = 0


## Coroutine function; call once to print the whole message
# NOTE: This could be done better by adding chars from a string into the label text...
func printText():
	# For slowing down sound playback
	var playSnd = 0
	
	# Don't try to start printing again if we're already doing it
	if printing:
		return
	
	# -- Main printing loop --
	printing = true
	while printing:
		# Add a letter to the end
		dialogLabel.visible_characters += 1
		
		# Play a sound at interval
		# NOTE: Audio might be able to be done in a slightly better way
		# https://kidscancode.org/godot_recipes/4.x/audio/audio_manager/index.html
		playSnd += 1
		if playSnd % 3 == 0:
			var choice: int = randi_range(0, len(sounds)-1)
			speaker.stream = sounds[choice]
			speaker.pitch_scale = randf_range(0.2, 0.3)
			speaker.play()
		
		# Exit if we're finshed printing the string
		if dialogLabel.visible_ratio >= 1:
			printing = false
			break
		await get_tree().create_timer(speed, false).timeout
