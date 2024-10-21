class_name PlayerHud extends Control

@export var interactionText: Label

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# -- Getters/setters --
## Get reference to interaction text label
func getInteractionText() -> Label:
	return interactionText
