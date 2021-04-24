extends Node2D
class_name Item

const ExpAffix = preload("res://affixes/exp_affix/exp_affix.tscn")
const LinAffix = preload("res://affixes/lin_affix/lin_affix.tscn")

export var image_path = "res://resources/icons/tile000.png"
export var item_level = 0
export var base_item_name = "Item"
export var item_name = "Item"
export var type = "weapon"
export var rarity = "common"
export var possible_affixes = []
export var implicit_stats = {}

var max_pref = 2
var max_suff = 2
var affix_count_to_roll = 0
var affix_count = 0
var pref_count = 0
var suff_count = 0
var prefixes = []
var suffixes = []
var stats = {}
var affixes = []


func make_item_name():
	var prefix = ""
	if prefixes:
		prefix = prefixes[randi() % prefixes.size()]
	var suffix = ""
	if suffixes:
		suffix = suffixes[randi() % suffixes.size()]
	item_name = prefix + " " + base_item_name + " " + suffix


func print_item():
	print("================================================")
	print("Item name: " + item_name)
	print("Rarity: " + rarity)
	print("Affixes: " + str(affixes))
	print("Stats: " + str(stats) + str(implicit_stats))
	print("================================================\n")


func initialize(_item_level = 1, _rarity = "common"):
	set_rarity(_rarity)
	item_level = _item_level
	roll_affixes(affix_count_to_roll)


func apply_stats(negative = false):
	for stat in implicit_stats:
		if negative:
			PlayerStats.set(stat, PlayerStats.get(stat) - implicit_stats[stat])
		else:
			PlayerStats.set(stat, PlayerStats.get(stat) + implicit_stats[stat])
	for stat in stats:
		if negative:
			PlayerStats.set(stat, PlayerStats.get(stat) - stats[stat])
		else:
			PlayerStats.set(stat, PlayerStats.get(stat) + stats[stat])


func unequip():
	apply_stats(true)
	PlayerStats.add_to_inv(self)


func equip():
	apply_stats()


func roll_affixes(count):
	randomize()
	clear_affixes()
	for _i in range(count):
		add_affix()
	make_item_name()


func clear_affixes():
	stats = {}
	affixes = []
	pref_count = 0
	suff_count = 0
	for node in $Affixes.get_children():
		$Affixes.remove_child(node)
		node.queue_free()


func get_affixes():
	affixes = []
	for affix in $Affixes.get_children():
		affixes.append(affix.affix_name)


func count_pref_suff():
	pref_count = 0
	suff_count = 0
	for affix in $Affixes.get_children():
		if affix.prefix:
			pref_count += 1
		elif affix.suffix:
			suff_count += 1


func add_child_affix(affix : Resource):
	if affix.has_signal("exp_affix"):
		var new_affix = ExpAffix.instance()
		$Affixes.add_child(new_affix)
		new_affix.initialize(affix.affix_name, affix.exponent, affix.affix_stats, affix.prefix, affix.suffix, affix.added_base, affix.multiplier)
	elif affix.has_signal("lin_affix"):
		var new_affix = LinAffix.instance()
		$Affixes.add_child(new_affix)
		new_affix.initialize(affix.affix_name, affix.multiplier, affix.affix_stats, affix.prefix, affix.suffix, affix.added_base)
	affix_count += 1
	affixes.append(affix.affix_name)
	if affix.prefix:
		pref_count += 1
		prefixes.append(affix.affix_name)
	elif affix.suffix:
		suff_count += 1
		suffixes.append(affix.affix_name)


func count_affixes():
	affix_count = $Affixes.get_child_count()


func add_prefix():
	randomize()
	var total_weight = 0
	for affix in possible_affixes:
		if affix.prefix and not affix.affix_name in affixes:
			total_weight += affix.weight
	var roll = randi() % total_weight
	for affix in possible_affixes:
		if affix.prefix and not affix.affix_name in affixes:
			if roll <= affix.weight:
				add_child_affix(affix)
				break
			else:
				roll -= affix.weight


func add_suffix():
	randomize()
	var total_weight = 0
	for affix in possible_affixes:
		if affix.suffix and not affix.affix_name in affixes:
			total_weight += affix.weight
	var roll = randi() % total_weight
	for affix in possible_affixes:
		if affix.suffix and not affix.affix_name in affixes:
			if roll <= affix.weight:
				add_child_affix(affix)
				break
			else:
				roll -= affix.weight


func add_affix():
	if pref_count == max_pref:
		add_suffix()
	elif suff_count == max_suff:
		add_prefix()
	else:
		var total_weight = 0
		for affix in possible_affixes:
			if not affix.affix_name in affixes:
				total_weight += affix.weight
		var roll = randi() % total_weight
		for affix in possible_affixes:
			if not affix.affix_name in affixes:
				if roll <= affix.weight:
					add_child_affix(affix)
					break
				else:
					roll -= affix.weight


func set_rarity(_rarity):
	randomize()
	rarity = _rarity
	if rarity == "common":
		affix_count_to_roll = 0
		max_pref = 0
		max_suff = 0
	elif rarity == "uncommon":
		affix_count_to_roll = 1 + randi() % 2
		max_pref = 1
		max_suff = 1
	elif rarity == "rare":
		affix_count_to_roll = 3 + randi() % 2
		max_pref = 2
		max_suff = 2











