extends Node2D
class_name Skill

export var base_cooldown = float(1)
export var priority = 5
export var skill_name = ""
export var icon_path = ""
export var level = 1
export var description = ""

#TAGS
export var phys = false
export var magic = false
export var attack = false
export var cast_on_self = false

var cooldown = float(1)
var can_use_skill = true


signal used_skill


func _ready():
	connect("used_skill", CombatProcessor, "_on_player_used_skill")
	cooldown = base_cooldown


func set_attacker_and_target():
	pass


func use_skill(attacker, target):
	spec_use_skill(attacker, target)
	if attacker.has_signal("is_player"):
		CombatProcessor.process_skill_exp(skill_name)


func spec_use_skill(attacker, target):
	pass


func skill_is_ready():
	can_use_skill = true


func put_skill_on_cooldown():
	$Cooldown.start(cooldown)
	can_use_skill = false


func can_use_skill(attacker, target):
	if can_use_skill and attacker != null and target != null and not attacker.dead and target.can_be_attacked and not target.dead:
		if (get_parent().get_parent().has_signal("is_monster")) or (get_parent().get_parent().has_signal("is_player") and CombatProcessor.next_action_ready):
			return true
	else:
		return false


func try_to_use_skill(attacker, target):
	if can_use_skill(attacker, target):
		use_skill(attacker, target)
		put_skill_on_cooldown()
		if get_parent().get_parent().has_signal("is_player"):
			emit_signal("used_skill", skill_name)
		return true
	else:
		return false


func _on_Cooldown_timeout():
	skill_is_ready()


func play_animation(animation):
	get_parent().get_parent().stop()
	get_parent().get_parent().frame = 0
	get_parent().get_parent().play(animation)
