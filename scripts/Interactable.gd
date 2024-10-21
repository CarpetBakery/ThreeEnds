class_name Interactable extends Area3D

@export var meshInst: MeshInstance3D
@export_multiline var interactionText: String

#const MP_ROOM = preload("res://maps/mpRoom.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onInteract(player: PlayerFps):
	print("Interacted!!")
	#get_tree().change_scene_to_packed(MP_ROOM)
	#get_tree().change_scene_to_file("res://maps/mpRoom.tscn")
	
	pass
