class_name DayManager extends Node

"""
Inherit from this class to get different functionality based on day
"""

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
