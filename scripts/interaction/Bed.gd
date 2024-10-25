class_name Bed extends Interactable

@export var vineBoom: AudioStreamPlayer
@onready var audiofade: AnimationPlayer = $"../../../Audiofade"

var playerWakePos := Vector3(1.465, 0.25, -7.909)
var playerWakeRot := Vector3(0, -130, 0)

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
	if Global.dayFinished1:
		_sleepRoutine(_player)
	else:
		cantSleep(_player)
	

func _day2(_player: PlayerFps) -> void:
	if Global.dayFinished2:
		_sleepRoutine(_player)
	else:
		cantSleep(_player)


func _day3(_player: PlayerFps) -> void:
	if Global.dayFinished3:
		_sleepRoutine(_player)
	else:
		cantSleep(_player)


func cantSleep(_player: PlayerFps):
	_player.addDialog("I can't sleep yet.")
	_player.startDialog()

func _sleepRoutine(_player: PlayerFps) -> void:
	print("Day is " + str(Global.day))
	
	# TODO: Fade out the audio
	audiofade.play("fadeAudio")
	
	_player.startTransition(false)
	await _player.hud.animationPlayer.animation_finished
	await get_tree().create_timer(3).timeout
	
	_player.addDialog("Tomorrow is another day.")
	_player.startDialog()
	
	await _player.dialogFinished
	
	await get_tree().create_timer(2).timeout
	
	Global.nextDay()
	print("Day is now " + str(Global.day))
	
	# Set player wake pos
	_player.position = playerWakePos
	_player.rotation = playerWakeRot
	_player.head.rotation = Vector3(0, 0, 0)
	_player.neck.rotation = Vector3(0, 0, 0)
	_player.eyes.rotation = Vector3(0, 0, 0)
	
	await get_tree().create_timer(3)
	
	vineBoom.play()
	audiofade.play("RESET")
	
	_player.startTransition(true, 9999)
	
	_player.hud.dayIntro.show()
	if Global.day == Global.Day.ONE:
		_player.hud.dayIntro.text = "Day 1"
	if Global.day == Global.Day.TWO:
		_player.hud.dayIntro.text = "Day 2"
	if Global.day == Global.Day.THREE:
		_player.hud.dayIntro.text = "Day 3"
	
	await _player.hud.animationPlayer.animation_finished
	
	await get_tree().create_timer(3).timeout
	_player.hud.dayIntro.hide()
	
	
