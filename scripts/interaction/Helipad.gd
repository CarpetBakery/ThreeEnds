class_name Helipad extends HoldInteract

@export var audioFade: AnimationPlayer

func _ready() -> void:
    super()
    holdTime = 5


func inFocus(_player: PlayerFps):
    var temp: String = interactionText
    if holding:
        interactionText = "Waiting..."
    
    super(_player)
    interactionText = temp


func onSuccessfulInteract(_player: PlayerFps):
    # Fade out, ending 1 of 3
    _player.startTransition(false, 2)
    audioFade.play("fadeAudio")
    await _player.hud.animationPlayer.animation_finished

    await get_tree().create_timer(2).timeout

