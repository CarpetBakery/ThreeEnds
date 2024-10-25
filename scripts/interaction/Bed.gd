class_name Bed extends Interactable

func onInteract(_player: PlayerFps):
	match Global.day:
		Global.Day.ZERO:
			_day0(_player)
		Global.Day.ONE:
			_day1(_player)
		Global.Day.TWO:
			_day2(_player)
		Global.Day.THREE:
			_day3(_player)


func _day0(_player: PlayerFps) -> void:
	# Just go to sleep
	_sleepRoutine(_player)
	pass


func _day1(_player: PlayerFps) -> void:
	_sleepRoutine(_player)
	pass


func _day2(_player: PlayerFps) -> void:
	_sleepRoutine(_player)
	pass


func _day3(_player: PlayerFps) -> void:
	_sleepRoutine(_player)
	pass


func _sleepRoutine(_player: PlayerFps) -> void:
	print("Thjat worked")
	
	# TODO:
	# Fade to black
	# Advance the day
	
	_player.startTransition(true)
	
	_player.addDialog("goodnight")
	_player.addDialog("The day is now " + str(Global.day))
	_player.startDialog()
	
	
	Global.nextDay()
