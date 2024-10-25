extends Node

## Singleton for providing global functions and variables

# -- Constants --
const DEBUG_MODE : bool = true

# -- Global vars --
## Current day enum
enum Day
{
	ZERO,
	ONE,
	TWO,
	THREE
}
## The current day
var day: Day = Day.ZERO
## Timer of the current day
var dayTimer: float = 0


# -- Scene transition --
var transition: bool = false


func _ready():
	# Limit framerate
	Engine.max_fps = 60
	
	# Change the "application surface"
	# (there is definitely a better way to do this... it's so blurry)
	#get_viewport().scaling_3d_scale = 0.1
	
	print_rich("[rainbow][wave][shake]We are bound by the conciousness that enables us")

func _process(delta):
	# Go fullscreen
	if Input.is_action_just_pressed("ui_fullscreen"):
		if get_window().mode == Window.MODE_WINDOWED:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED
	
	# Debug stuff
	if DEBUG_MODE:
		# Restart the current scene
		if Input.is_action_just_pressed("debug_restart"):
			get_tree().reload_current_scene()
		pass


## Increase the day
func nextDay() -> void:
	if Global.Day.ZERO:
		Global.day = Global.Day.ZERO
	elif Global.Day.ONE:
		Global.day = Global.Day.ONE
	elif Global.Day.TWO:
		Global.day = Global.Day.TWO
	elif Global.Day.THREE:
		Global.day = Global.Day.THREE
