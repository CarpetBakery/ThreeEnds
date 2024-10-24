class_name PlayerHud extends Control

@export var crosshair: ColorRect
@export var interactionText: Label
@export var dialogText: Label
@export var progressBar: ProgressBar

func _ready() -> void:
	# Hide/show everything
	crosshair.show()
	interactionText.hide()
	dialogText.show()
	progressBar.hide()
	
	dialogText.text = ""
	
