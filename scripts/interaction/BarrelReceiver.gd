class_name BarrelReceiver extends Interactable

var barrelCount: int = 0

func onInteract(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.dropObject()
		addBarrel()
		print(barrelCount)

func inFocus(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.setInteractionText("Place barrel")
	else:
		_player.setInteractionText("Barrel receiver")

func addBarrel():
	barrelCount += 1
