class_name RoomManager extends DayManager

@export var player: PlayerFps

func _ready() -> void:
	if TransitionManager.transition:
		_readyTransition()

func _readyTransition():
	# Put the player in the correct position
	if Global.transitionFromComputer:
		Global.transitionFromComputer = false
		
		# Put the player in front of the computer
		var pos := Vector3(-3.845, 0.258, -5.765)
		var rot := Vector3(0, 177.7, 0)
		Global.setPlayerPos(player, pos, rot)
	

func _process(delta: float) -> void:
	## Execute function based on day
	match Global.day:
		Global.Day.ZERO:
			_dayProcess0(delta)
		Global.Day.ONE:
			_dayProcess1(delta)
		Global.Day.TWO:
			_dayProcess2(delta)
		Global.Day.THREE:
			_dayProcess3(delta)

## Override these 
func _dayProcess0(_delta: float):
	pass
func _dayProcess1(_delta: float):
	pass
func _dayProcess2(_delta: float):
	pass
func _dayProcess3(_delta: float):
	pass
