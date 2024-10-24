class_name HoldInteract extends Interactable

"""
Interactable that you have to press and hold to interact with
"""

## How long (in seconds) you have to hold for
@export var holdTime: float = 0.4
# Reference to the player object
@export var playerRef: PlayerFps = null

## Used for the hold time
var timer: Timer = Timer.new()
## Are we holding?
var holding: bool = false


func _ready() -> void:
	# Set collision layer to '2'
	super()
	
	# If player reference is null, crash the game
	assert(playerRef != null)
	
	# Setup timer
	add_child(timer)
	# Don't restart after firing
	timer.one_shot = true
	timer.timeout.connect(_onTimeout)


func _process(_delta: float) -> void:
	if holding:
		# Get time as a scale from 0-1
		var tScale = timer.time_left / max(holdTime, 0)
		
		# Update the progress bar in the player's HUD
		var pBar: ProgressBar = playerRef.getHud().progressBar
		# Show progress bar
		pBar.show()
		pBar.value = 100 - (tScale * 100)
		
		# If we aren't holding the interaction button anymore then stop
		if not Input.is_action_pressed("interact"):
			# Reset timer (hopefully this doesn't make it fire)
			holding = false
			timer.stop()
			
			# Allow player to look again
			playerRef.freezeMovement = false


func onInteract(_player: PlayerFps):
	startHold(_player)


## Start the hold routine
func startHold(_player: PlayerFps):
	# Start the timer
	timer.start(holdTime)
	holding = true
	
	# Stop the player from being able to look
	_player.freezeMovement = true


## Callback func when the timer times out
func _onTimeout():
	holding = false
	
	# Allow player to look again
	playerRef.freezeMovement = false
	
	onSuccessfulInteract(playerRef)


## Called when the hold interaction is successful
## Override this for functionality on success
func onSuccessfulInteract(_player: PlayerFps):
	pass
