class_name UiTest extends Node

@onready var scoreLabel: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Label

var score = 0:
	set(newScore):
		score = newScore
		_updateScoreLabel()

func _ready() -> void:
	_updateScoreLabel()

func _updateScoreLabel():
	scoreLabel.text = str(score)
