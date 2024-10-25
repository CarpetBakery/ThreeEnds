class_name ManagerOutside extends DayManager

@export var player: PlayerFps
@export var audioFade: AnimationPlayer
@export var vineBoom: AudioStreamPlayer

# Class for managing state in the map outside

@export_group("Day 1")
@export var dayParent1: Node3D
@export var switchLeft: DrillSwitch
@export var switchRight: DrillSwitch

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

func _process(delta: float) -> void:
	super(delta)
	
	# Kill player below y value
	if player.position.y < -20 and not player.dying:
		player.die()
		audioFade.play("fadeAudio")
		
		player.addDialog("I think I am dying.")
		player.startDialog()
		
		await player.dialogFinished
		
		vineBoom.play()
		player.addDialog("ENDING 1 OF 3")
		player.startDialog()
		
		await player.dialogFinished
		await get_tree().create_timer(3).timeout
		Global.resetGame()
		

func _dayProcess1(_delta: float):
	if not Global.dayFinished1:
		if switchLeft.disabled and switchRight.disabled:
			# Day activities completed
			Global.dayFinished1 = true

func _dayProcess2(_delta: float):
	pass


func _dayProcess3(_delta: float):
	pass
