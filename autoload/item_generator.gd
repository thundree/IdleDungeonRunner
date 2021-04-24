extends Node

const TestWeapon = preload("res://items/weapons/test_weapon.tscn")
const TestBodyArmor = preload("res://items/body_armors/test_body_armor.tscn")
const TestHelmet = preload("res://items/helmets/test_helmet.tscn")
const TestBoots = preload("res://items/boots/test_boots.tscn")

var rng = RandomNumberGenerator.new()

var min_floor = {"TestWeapon": 1, "Shortsword": 5, "Longsword": 5}


func log_base(base, x):
	return (log(x)/log(base))


func gauss_range(minval, maxval):
	rng.randomize()
	var num = round(rng.randfn(0, 2.5))
	if (minval <= num) and (num <= maxval):
		return num
	else:
		return gauss_range(minval, maxval)


func gauss_level_range(value, level):
	return max(1, (gauss_range(-value, value) + level))


func make_test_item(type, item_level, rarity):
	var test_item = null
	if type == "weapon":
		test_item = TestWeapon.instance()
	elif type == "body_armor":
		test_item = TestBodyArmor.instance()
	elif type == "boots":
		test_item = TestBoots.instance()
	elif type == "helmet":
		test_item = TestHelmet.instance()
	test_item.initialize(item_level, rarity)
	return test_item


func generate_item(base, item_level, rarity):
	var item = get(base).instance()
	item.initialize(item_level, rarity)


func generate_loot(zone, monster):
	pass

