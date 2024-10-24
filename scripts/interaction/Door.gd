class_name Door extends Interactable

func onInteract(_player: PlayerFps):
	_player.addDialog("I need to turn off the DRILLS.")
	_player.startDialog()
