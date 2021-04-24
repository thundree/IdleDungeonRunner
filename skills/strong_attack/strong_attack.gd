extends Skill

var base_added_damage = 20
var added_damage = 20
var base_damage = 0
var base_damage_multi = 1.2
var level_exp = 1.4
var damage = 0


func calculate_base_damage():
	added_damage = base_added_damage * (1 + (level - 1) / 2)
	base_damage = get_parent().get_parent().stats["phys_damage"] * base_damage_multi + added_damage


func calculate_level_damage(damage):
	damage = (pow(level, level_exp) / 100 + 1) * damage
	return damage


func calculate_damage():
	calculate_base_damage()
	return calculate_level_damage(base_damage)


func spec_use_skill(attacker, target):
	if get_parent().get_parent() != null:
		if get_parent().get_parent().get_class() == "AnimatedSprite":
			play_animation("attack_alt")
	damage = calculate_damage()
	CombatProcessor.process_damage(damage, attacker, target, "phys")
