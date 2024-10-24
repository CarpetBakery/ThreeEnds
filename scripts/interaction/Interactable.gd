class_name Interactable extends Area3D

"""
* Inherit from this class to create interactable objects
	- Derives from Area3D
	- Requires a CollisionShape3D
"""

## Text displayed when you're looking at an object
@export_multiline var interactionText: String

@export_category("Interaction flags")
## Can we interact with this object?
@export var canInteract: bool = true
## Can the player focus on this object?
@export var canFocus: bool = true


## Whether or not this node is currently focused by the player
var focused: bool = false


## Set the collision mask to 2
func _ready() -> void:
	collision_layer = 2

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
