class_name BarrelReceiver extends HoldInteract

var barrelCount: int = 0

func inFocus(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.setInteractionText("Place barrel")
	else:
		_player.setInteractionText("Barrel receiver")

# Instant interaction
func onInteract(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		startHold(_player)
	else:
		# playerRef.showDialog("It's a barrel reciever thing...")
		
		playerRef.addDialog("It's a barrel reciever thing...")
		playerRef.addDialog("Not sure what to do with this")
		playerRef.startDialog()


# Long interaction
func onSuccessfulInteract(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.dropObject()
		addBarrel()
		
		playerRef.showDialog("That's barrel #" + str(barrelCount) + ", fuck yeah!")

func addBarrel():
	barrelCount += 1
