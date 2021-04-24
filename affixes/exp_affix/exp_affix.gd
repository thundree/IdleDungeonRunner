extends Affix

export var exponent = 1.1
export var bases = {"stat": 0}
export var added_base = 0
export var multiplier = 1


func calculate_value(base):
	var level = ItemGenerator.gauss_level_range(5, get_parent().get_parent().item_level)
	return ((pow(level, exponent) + 1) * base + added_base) * multiplier


func calculate_stats():
	affix_stats = {}
	for affix_stat in bases:
		affix_stats[affix_stat] = calculate_value(bases[affix_stat])


func initialize(_name, _exponent, _stats, _prefix, _suffix, _added_base, _multiplier):
	affix_name = _name
	exponent = _exponent
	bases = _stats
	added_base = _added_base
	multiplier = _multiplier
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
