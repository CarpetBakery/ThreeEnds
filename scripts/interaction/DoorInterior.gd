class_name DoorInterior extends Interactable

@onready var audiofade: AnimationPlayer = $"../../../Audiofade"
@onready var doorOpen: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"

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


func _day0(_player: PlayerFps):
	_player.addDialog("I should go to bed.")
	_player.startDialog()


func _day1(_player: PlayerFps):
	if not Global.dayFinished1:
		gotoRig(_player)
	else:
		_player.addDialog("I should go to bed.")
		_player.startDialog()


func _day2(_player: PlayerFps):
	if not Global.dayFinished2:
		gotoRig(_player)
	else:
		_player.addDialog("I should go to bed.")
		_player.startDialog()


func _day3(_player: PlayerFps):
	if not Global.dayFinished3:
		_player.addDialog("I need to pack my bags first.")
		_player.startDialog()
	else:
		gotoRig(_player)
		
	#else:
		#_player.addDialog("I should go to bed.")
		#_player.startDialog()


func gotoRig(_player: PlayerFps):
	audiofade.play("fadeAudio")
	_player.startTransition(false)
	await _player.hud.animationPlayer.animation_finished
	
	doorOpen.play()
	
	await get_tree().create_timer(1.5).timeout
	
	TransitionManager.gotoScene("res://maps/mpOilRigBlockout.tscn")
