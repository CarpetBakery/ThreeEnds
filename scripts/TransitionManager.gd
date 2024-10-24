extends Node

## Turned on whenever a new scene starts and the previous one had a transition flag set
var transition: bool = false

func gotoScenePacked(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
	
	transition = true
	await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	transition = false

func gotoScene(scene: String):
	get_tree().change_scene_to_file(scene)
	
	# Wait, otherwise signal gets emitted on the same frame that this is called
	transition = true
	await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	transition = false
