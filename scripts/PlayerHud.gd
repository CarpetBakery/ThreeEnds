class_name PlayerHud extends Control

@export var crosshair: ColorRect
@export var interactionText: Label
@export var progressBar: ProgressBar

@export_category("Dialog")
@export var dialogText: Label
@export var cinemaBars: Array[ColorRect]

func _ready() -> void:
	# Hide/show everything
	crosshair.show()
	interactionText.hide()
	dialogText.show()
	progressBar.hide()
	
	# Set up dialog
	dialogText.text = ""
	for i in cinemaBars:
		i.hide()


func toggleCinemaBars(on: bool):
	for i in cinemaBars:
		i.visible = on
