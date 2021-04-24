extends Skill

const AddedArmor = preload("res://effects/added_armor/added_armor.tscn")

var base_added_armor = 100
var added_armor = 100
var base_armor = 0
var level_exp = 1.35
var armor = 0
var armor_duration = 5

func calculate_base_armor():
	added_armor = base_added_armor * (1 + (level - 1) / 2)
	base_armor = added_armor


func calculate_level_armor(armor):
	armor = (pow(level, level_exp) / 100 + 1) * armor
	return armor


func calculate_armor():
	calculate_base_armor()
	return calculate_level_armor(base_armor)


func spec_use_skill(attacker, target):
	if get_parent().get_parent() != null:
		if get_parent().get_parent().get_class() == "AnimatedSprite":
			play_animation("attack")
	armor = calculate_armor()
	CombatProcessor.apply_effect(attacker, target, AddedArmor, [armor], armor_duration)
