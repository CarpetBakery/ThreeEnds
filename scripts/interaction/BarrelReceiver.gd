class_name BarrelReceiver extends HoldInteract

var barrelCount: int = 0

func inFocus(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.setInteractionText("Place barrel")
	else:
		_player.setInteractionText("Barrel receiver")

func onInteract(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		startHold(_player)
	else:
		print("It's a barrel thing...")

func onSuccessfulInteract(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.dropObject()
		addBarrel()
		print(barrelCount)

func addBarrel():
	barrelCount += 1
