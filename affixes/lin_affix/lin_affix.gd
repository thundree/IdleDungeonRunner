extends Affix

export var multiplier = 1.0
export var bases = {"stat": 0}
export var added_base = 0.0


func calculate_value(base):
	var level = ItemGenerator.gauss_level_range(5, get_parent().get_parent().item_level)
	return base * level * multiplier + added_base


func calculate_stats():
	affix_stats = {}
	for affix_stat in bases:
		affix_stats[affix_stat] = calculate_value(bases[affix_stat])


func initialize(_name, _multiplier, _stats, _prefix, _suffix, _added_base):
	affix_name = _name
	multiplier = _multiplier
	bases = _stats
	added_base = _added_base
	if _prefix:
		prefix = true
		suffix = false
	elif _suffix:
		suffix = true
		prefix = false
	calculate_stats()
	apply_affix()


func print_affix():
	print("Affix name: " + affix_name)
	print(affix_stats)
