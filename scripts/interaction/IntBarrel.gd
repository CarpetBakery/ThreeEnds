class_name IntBarrel extends HoldInteract

## Parent node
@export var parent: RigidBody3D


func onInteract(_player: PlayerFps):
	if (_player.carryObject == _player.CarryType.NONE):
		startHold(_player)
	else:
		_player.addDialog("You're already holding something.")
		_player.startDialog() 

func onSuccessfulInteract(_player: PlayerFps):
	_player.pickupObject(PlayerFps.CarryType.BARREL)
	
	_player.startDialog()
	
	# NOTE: doesn't get rid of collision
	#parent.hide()
