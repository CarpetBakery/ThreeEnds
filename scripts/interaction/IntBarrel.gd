class_name IntBarrel extends HoldInteract

## Parent node
@export var parent: RigidBody3D

func onInteract(_player: PlayerFps):
	if (_player.carryObject == _player.CarryType.NONE):
		startHold(_player)
	else:
		print("You're already holding something!")

func onSuccessfulInteract(_player: PlayerFps):
	_player.pickupObject(PlayerFps.CarryType.BARREL)
	
	# NOTE: doesn't get rid of collision
	#parent.hide()
