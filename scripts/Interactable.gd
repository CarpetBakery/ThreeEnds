class_name Interactable extends Area3D

@export var meshInst: MeshInstance3D
@export var interactionText: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onInteract(player: PlayerFps):
	print("Interacted!!")
	pass