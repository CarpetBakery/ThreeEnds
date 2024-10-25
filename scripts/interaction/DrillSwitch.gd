class_name DrillSwitch extends HoldInteract

enum Drill { LEFT, RIGHT }

@export var drill: Drill

func inFocus(_player: PlayerFps):
	var temp: String = interactionText
	if holding:
		interactionText = "Turning off drill..."
	
	super(_player)
	interactionText = temp

func onSuccessulInteract(_player: PlayerFps):
	# TODO: Play sound
	
	
	pass
