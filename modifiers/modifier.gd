extends Node2D
class_name Modifier


export var mod_name = "Modifier"
export var level = 1
export var prefix = false
export var suffix = false
var parent = null


func apply_effect():
	print("ERROR : Tried to apply effect of empty modifier")


func _ready():
	parent = get_parent().get_parent()
	initialize(parent.level)
	apply_effect()


func initialize(_level):
	level = _level
