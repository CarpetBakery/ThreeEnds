class_name PlayerHud extends Control

@export var interactionText: Label
@export var progressBar: ProgressBar

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# -- Getters/setters --
func getInteractionText() -> Label:
	return interactionText

func getProgressBar() -> ProgressBar:
	return progressBar
	
