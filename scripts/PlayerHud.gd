class_name PlayerHud extends Control

@export var crosshair: ColorRect
@export var interactionText: Label
@export var progressBar: ProgressBar
@export var black: ColorRect
@export var white: ColorRect
@export var animationPlayer: AnimationPlayer
@export var barsAnimation: AnimationPlayer
@export var dayIntroAnimation: AnimationPlayer

@export_category("Dialog")
@export var dialogParent: Control
@export var dialogText: Label
@export var cinemaBars: Array[ColorRect]

@export_category("Sleep")
@export var dayIntro: Label
@export var daySubtitle: Label

## Whether or not to play UI animations
@export var playAnimations: bool = false

func _ready() -> void:
	# Hide/show everything
	crosshair.show()
	interactionText.show()
	progressBar.hide()
	black.hide()
	white.hide()
	
	dialogParent.show()
	dialogText.show()
	toggleCinemaBars(true)
	
	dayIntro.hide()
	daySubtitle.hide()
	
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


func setDayIntroText(title: String, subtitle: String):
	dayIntro.text = title
	daySubtitle.text = subtitle
