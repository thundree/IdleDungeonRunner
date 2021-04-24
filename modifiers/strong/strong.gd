extends Modifier

var base_phys_damage = 10
var level_multi = 2


func calculate_level_phys_damage(level):
	return base_phys_damage + level * level_multi


func apply_effect():
	parent.stats["phys_damage"] += calculate_level_phys_damage(level)


