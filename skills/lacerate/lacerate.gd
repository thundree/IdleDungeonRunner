extends Skill

const Bleeding = preload("res://effects/bleeding/bleeding.tscn")


var base_added_damage = 10
var added_damage = 10
var base_damage = 0
var level_exp = 1.35
var damage = 0
var bleed_duration = 2


func calculate_base_damage():
	added_damage = base_added_damage * (1 + (level - 1) / 2)
	base_damage = get_parent().get_parent().stats["phys_damage"] + added_damage


func calculate_level_damage(damage):
	damage = (pow(level, level_exp) / 100 + 1) * damage
	return damage

func calculate_bleed_damage(damage):
	return damage / 5


func calculate_damage():
	calculate_base_damage()
	return calculate_level_damage(base_damage)


func spec_use_skill(attacker, target):
	if get_parent().get_parent() != null:
		if get_parent().get_parent().get_class() == "AnimatedSprite":
			play_animation("attack_alt")
	damage = calculate_damage()
	var damage_dealt = CombatProcessor.process_damage(damage, attacker, target, "phys")
	var bleed_damage = calculate_bleed_damage(damage_dealt)
	CombatProcessor.apply_effect(attacker, target, Bleeding, [bleed_damage], bleed_duration)
