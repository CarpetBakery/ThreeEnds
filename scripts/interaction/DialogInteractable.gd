class_name DialogInteractable extends Interactable

## Dialog lines
@export_category("Dialog lines")
@export_multiline var dialogLines: Array[String]

func onInteract(_player: PlayerFps):
	for i in dialogLines:
		_player.addDialog(i)
	_player.startDialog()
