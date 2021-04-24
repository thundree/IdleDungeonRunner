extends Node2D
class_name Effect

export var image_path = ""
export var base_duration = 0.0
export var base_tick_duration = 0.0
var duration = 0.0
var tick_duration = 0.0
export var tick_based = true

func initialize(attacker, target, args : Array, duration : float):
	pass


func update_duration(attacker, target):
	duration *= attacker.stats["effect_duration_multi"]
	$EffectTime.wait_time = duration
	$TickTime.wait_time = tick_duration


func _on_EffectTime_timeout():
	if not tick_based:
		apply_effect(true)
	queue_free()


func _on_TickTime_timeout():
	if tick_based:
		apply_effect()


func apply_effect(negative = false):
	pass


func add_self_to_parent(parent):
	parent.get_node("Effects").add_child(self)
