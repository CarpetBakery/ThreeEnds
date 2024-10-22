class_name Interactable extends Area3D

## Text displayed when you're looking at an object
@export_multiline var interactionText: String

## Whether or not this node is currently focused by the player
var focused: bool

## Called once when the object comes into focus
func enterFocus(_player: PlayerFps):
	pass

## Called once when the object goes out of focus
func exitFocus(_player: PlayerFps):
	pass

## Called every frame when the player is in interaction range of the object (sets interaction text by default)
func inFocus(_player: PlayerFps):
	_player.setInteractionText(interactionText)

## Called when the player presses the interact key on this object
func onInteract(_player: PlayerFps):
	#print("Interacted!!")
	#get_tree().change_scene_to_packed(MP_ROOM)
	#get_tree().change_scene_to_file("res://maps/mpRoom.tscn")
	pass
