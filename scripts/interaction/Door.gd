class_name Door extends Interactable

func onInteract(_player: PlayerFps):
	_player.addDialog("I need to turn off the DRILLS.")
	_player.startDialog()

func _day0(_player: PlayerFps):
	pass

func _day1(_player: PlayerFps):
	pass

func _day2(_player: PlayerFps):
	pass

func _day3(_player: PlayerFps):
	pass
