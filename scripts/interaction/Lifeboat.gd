class_name Lifeboat extends HoldInteract

@export var audioFade: AnimationPlayer

var interactCount = 0

func onInteract(_player: PlayerFps):
	if interactCount == 0:
		_player.addDialog("Hm... I forgot this was here.")
		_player.startDialog()
	elif interactCount == 1:
		_player.addDialog("I wonder if it still works...")
		_player.startDialog()
	elif interactCount == 2:
		_player.addDialog("Wouldn't hurt to take it for a spin.")
		_player.startDialog()
	elif interactCount == 3:
		_player.addDialog("Here I go!")
		_player.startDialog()
		
		await _player.dialogFinished
		
		# Fade out, ending 3 of 3
		_player.startTransition(false, 2)
		audioFade.play("fadeAudio")
		await _player.hud.animationPlayer.animation_finished
		
		await get_tree().create_timer(2).timeout

		_player.hud.credits.play("credits2")
		await _player.hud.credits.animation_finished
		
		Global.resetGame()
	
	interactCount += 1
