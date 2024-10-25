class_name PlayerHud extends Control

@export var crosshair: ColorRect
@export var interactionText: Label
@export var progressBar: ProgressBar
@export var black: ColorRect
@export var animationPlayer: AnimationPlayer
@export var barsAnimation: AnimationPlayer

@export_category("Dialog")
@export var dialogParent: Control
@export var dialogText: Label
@export var cinemaBars: Array[ColorRect]

@export_category("Sleep")
@export var dayIntro: Label

## Whether or not to play UI animations
@export var playAnimations: bool = false

func _ready() -> void:
	# Hide/show everything
	crosshair.show()
	interactionText.show()
	progressBar.hide()
	black.hide()
	
	dialogParent.show()
	dialogText.show()
	toggleCinemaBars(true)
	
	# Set up dialog
	dialogText.text = ""
	for i in cinemaBars:
		i.hide()


func toggleCinemaBars(on: bool):
	for i in cinemaBars:
		i.visible = on


# Make sure to set speed_scale back to 1 after calling this function
func fade(fadeIn: bool, spd: float = 1) -> void:
	black.show()
	animationPlayer.speed_scale = spd
	if fadeIn:
		animationPlayer.play("fadeFromBlack")
	else:
		animationPlayer.play("fadeToBlack")
	
