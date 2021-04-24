extends Modifier

var base_hp = 10
var level_multi = 2


func calculate_level_hp(level):
	return base_hp + level * level_multi


func apply_effect():
	parent.stats.max_hp += calculate_level_hp(level)


