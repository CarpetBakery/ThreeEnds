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
		if Global.dayFinished2:
			playerRef.addDialog("The ship is waiting for its oil...")
		else:
			playerRef.addDialog("The ship is full.")
		playerRef.startDialog()


# Long interaction
func onSuccessfulInteract(_player: PlayerFps):
	if _player.carryObject == _player.CarryType.BARREL:
		_player.dropObject()
		_player.barrelDown.play()
		addBarrel()
		
		if barrelCount >= 5:
			_player.addDialog("That should be everything for today.")
			_player.startDialog()
			Global.dayFinished2 = true
			
		
		#playerRef.addDialog("That's barrel #" + str(barrelCount) + ", hell yeah!")
		#playerRef.addDialog("WOOOOOO YEAH!!!!!!!!!!!!! \nQIOWRJOIQWR JQOWITJ QWOITJOIQWJT OQWTJ ")
		#playerRef.addDialog("qrijqwoijqwiot jqwotijqwoitjq owtijqwotj qopitjq owtpij  ")
		#playerRef.addDialog("LOREM IPSUM")
		#playerRef.startDialog()

func addBarrel():
	barrelCount += 1
