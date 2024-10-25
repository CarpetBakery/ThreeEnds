class_name DoorExterior extends Interactable

@export var manager: ManagerOutside

const MP_ROOM_BLOCKOUT = preload("res://maps/mpRoomBlockout.tscn")

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



func _day1(_player: PlayerFps):
	if not Global.dayFinished1:
		_player.addDialog("I need to turn off the DRILLS.")
		_player.startDialog()
	else:
		_player.startTransition(false)
		await _player.hud.animationPlayer.animation_finished
		TransitionManager.gotoScenePacked(MP_ROOM_BLOCKOUT)
	


func _day2(_player: PlayerFps):
	pass


func _day3(_player: PlayerFps):
	pass






func _day0(_player: PlayerFps):
	return
	_player.addDialog("If you're seeing this, I messsed up")
	_player.startDialog()

	await _player.dialogFinished
	# Don't allow the player to move
	_player.freezeMovement = true
	_player.canInteract = false
	
	# Fade out and transition to other scene
	_player.hud.fade(false)
	await _player.hud.animationPlayer.animation_finished
	
	await get_tree().create_timer(1.3).timeout
	TransitionManager.gotoScene("res://maps/mpRoomBlockout.tscn")
