class_name Closet extends HoldInteract

func _ready() -> void:
	super()
	holdTime = 2

func inFocus(_player: PlayerFps):
	if Global.day == Global.Day.THREE:
		var temp = interactionText
		
		if not Global.dayFinished3:
			interactionText = "Pack bags"
		
		super(_player)
		
		interactionText = temp
		return
	
	super(_player)


func onInteract(_player: PlayerFps):
	if Global.day == Global.Day.THREE:
		if not Global.dayFinished3:
			startHold(_player)
		else:
			_player.addDialog("It's my closet")
			_player.startDialog()
	else:
		_player.addDialog("It's my closet.")
		_player.addDialog("I keep all of my things\nin here.")
		_player.startDialog()


func onSuccessfulInteract(_player: PlayerFps):
	Global.dayFinished3 = true
	Global.todoString = "Wait on the helipad"
