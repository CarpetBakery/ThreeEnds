class_name Interactable extends Area3D

@export var meshInstance: MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onInteract():
	print("Interacted")
	pass
