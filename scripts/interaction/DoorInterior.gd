class_name DoorInterior extends Interactable

const MP_OIL_RIG_BLOCKOUT = preload("res://maps/mpOilRigBlockout.tscn")
@onready var audiofade: AnimationPlayer = $"../../../Audiofade"

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
	gotoRig(_player)
	
	#await get_tree().create_timer(1.3).timeout


func _day2(_player: PlayerFps):
	pass


func _day3(_player: PlayerFps):
	pass


func gotoRig(_player: PlayerFps):
	audiofade.play("fadeAudio")
	_player.startTransition(false)
	await _player.hud.animationPlayer.animation_finished
	
	await get_tree().create_timer(1.5).timeout
	
	TransitionManager.gotoScenePacked(MP_OIL_RIG_BLOCKOUT)
