class_name CarryBarrel extends CarryObject

# Rigidbody parent
@export var rb: RigidBody3D
@export var hitboxInteract: CollisionShape3D
@export var hitboxPhysics: CollisionShape3D

func onInteract(_player: PlayerFps):
	_player.addCarryObject(rb)
	_disable()

func onDrop(_player: PlayerFps):
	pass

func _disable():
	# Disable rigidbody physics
	rb.freeze = true
	
	# Disable hitboxes to stop interaction conflicts
	hitboxInteract.disabled = true
	hitboxPhysics.disabled = true


func _enable():
	rb.freeze = false
	
	hitboxInteract.disabled = false
	hitboxPhysics.disabled = false
