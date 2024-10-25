class_name Lifeboat extends HoldInteract

var interactCount = 0

func onInteract(_player: PlayerFps):
	if interactCount == 0:
		_player.addDialog("Hm... I forgot this was here.")
		_player.startDialog()
	elif interactCount == 1:
		
		pass
