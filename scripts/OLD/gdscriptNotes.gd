## -- UNUSED --

# Class name can be defined like this
class_name GdScriptNotes
# Inherit like this
extends Node

var foo = 1

func _ready():
	# "Match" is like a switch statement
	match foo:
		1:
			print("foo is 1")
		_:
			print("foo is something else")

func something(p1, p2):
	# An overridden function can call its parent with "super"
	#super(p1, p2)
	pass

# It's also possible to call another function in the super class
func other_something(p1, p2):
	#super.something(p1, p2)
	pass

# Inner class
class Something:
	var a = 10
	
	func addNumber():
		a += 1

# Constructor
func _init():
	var obj = Something.new()
	obj.addNumber()
	print(obj.a)
	
	print("Constructed!")
	
# Dictionaries exist like in Python
var dict = {"name": "bepis", "age": 22}

"""
In Godot class members can be exported, which means their value gets
saved along with the resource (such as the scene) they're attached to.
They will also be available for editing in the property editor
"""
@export var number: int = 5

"""
It is possible to group exported properties with @export_group
"""
@export_group("Stuff")
@export var thing: String

"""
There are also these
"""
@export_subgroup("Subgroup")
@export_category("Category 1")
