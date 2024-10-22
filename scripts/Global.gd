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


# Helper functions
#func lerp_angle(from, to, weight):
	#return from + _short_angle_dist(from, to) * weight
#
#func _short_angle_dist(from, to):
	#var max_angle = PI * 2
	#var difference = fmod(to - from, max_angle)
	#return fmod(2 * difference, max_angle) - difference
