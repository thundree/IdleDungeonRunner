extends Modifier


var base_armor = 10
var level_exp = 1.3


func calculate_level_armor(armor, level):
	armor = (pow(level, level_exp) / 100 + 1) * armor
	return armor


func apply_effect():
	parent.stats.armor += calculate_level_armor(level, base_armor)
