extends Interactable

func onInteract(_player: PlayerFps):
	_player.pickupObject(PlayerFps.CarryType.BARREL)
	hide()
