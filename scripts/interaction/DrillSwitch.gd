class_name DrillSwitch extends HoldInteract

enum Drill { LEFT, RIGHT }

@export var drill: Drill
@export var audio: AudioStreamPlayer3D

var disabled: bool = false

func _ready() -> void:
	super()
	holdTime = 1

func onInteract(_player: PlayerFps):
	if disabled:
		_player.addDialog("The drill is already off.")
		_player.startDialog()
		return
	
	super(_player)

func inFocus(_player: PlayerFps):
	if !disabled:
		var temp: String = interactionText
		
		if holding:
			interactionText = "Turning off drill..."
		
		super(_player)
		interactionText = temp
	else:
		var temp: String = interactionText
		interactionText += " (OFF)"
		super(_player)
		interactionText = temp

func onSuccessfulInteract(_player: PlayerFps):
	print("Working")
	disabled = true
	audio.play(0.4)
