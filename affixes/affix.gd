extends Node2D
class_name Affix

export var affix_name = "Affix"
export var affix_stats = {"stat": 0}
export var prefix = false
export var suffix = false


var item = null

func apply_affix():
	item = get_parent().get_parent()
	for affix_stat in affix_stats:
		if item.stats.has(affix_stat):
			item.stats[affix_stat] += affix_stats[affix_stat]
		elif !item.stats.has(affix_stat):
			item.stats[affix_stat] = affix_stats[affix_stat]
