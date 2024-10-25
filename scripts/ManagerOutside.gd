class_name ManagerOutside extends DayManager

# Class for managing state in the map outside

@export_group("Day 1")
@export var dayParent1: Node3D
@export var switchLeft: DrillSwitch
@export var switchRight: DrillSwitch
var day1Complete: bool = false

@export_group("Day 2")
@export var dayParent2: Node3D

@export_group("Day 3")
@export var dayParent3: Node3D


func _ready() -> void:
	# Delete stuff from days that we are not on
	if Global.day != Global.Day.ONE:
		dayParent1.queue_free()
	if Global.day != Global.Day.TWO:
		dayParent2.queue_free()
	if Global.day != Global.Day.THREE:
		dayParent3.queue_free()

func _dayProcess1(_delta: float):
	if not day1Complete:
		if switchLeft.disabled and switchRight.disabled:
			# Day activities completed
			day1Complete = true

func _dayProcess2(_delta: float):
	pass


func _dayProcess3(_delta: float):
	pass
