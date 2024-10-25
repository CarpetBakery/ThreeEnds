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
var day: Day = Day.THREE 
## Timer of the current day
var dayTimer: float = 0

# -- Day 0 --

# -- Day 1 --
var dayFinished1 := false

# -- Day 2 --
var dayFinished2 := false

# -- Day 3 --
var dayFinished3 := false

# -- Scene transition --
var transition: bool = false

var transitionFromComputer: bool = false
var transitionFromOutside: bool = false


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
	print(Global.day)
	
	if day == Day.ZERO:
		day = Day.ONE
	elif day == Day.ONE:
		day = Day.TWO
	elif day == Day.TWO:
		day = Day.THREE
	elif day == Day.THREE:
		day = Day.THREE


# -- Helper funcs --
func setPlayerPos(player: PlayerFps, pos: Vector3, rot: Vector3):
	player.position = pos
	#player.rotation = rot
	player.rotation_degrees = rot
	
	player.head.rotation = Vector3(0, 0, 0)
	player.neck.rotation = Vector3(0, 0, 0)
	player.eyes.rotation = Vector3(0, 0, 0)


func resetGame():
	day = Day.ZERO
	dayFinished1 = false
	dayFinished2 = false
	dayFinished3 = false
	
	TransitionManager.gotoScene("res://maps/mpComputer.tscn")
