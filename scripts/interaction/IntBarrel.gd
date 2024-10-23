class_name IntBarrel extends HoldInteract

func onSuccessfulInteract(_player: PlayerFps):
	super(_player)
	_player.pickupObject(PlayerFps.CarryType.BARREL)
	# hide()
