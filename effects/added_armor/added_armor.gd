extends Effect

var added_armor = 0
var target_is_player = false
var target_is_monster = false


func initialize(attacker, target, args, _duration):
	target_is_player = target.has_signal("is_player")
	target_is_monster = target.has_signal("is_monster")
	added_armor = args[0]
	duration = _duration
	update_duration(attacker, target)
	add_self_to_parent(target)
	apply_effect()


func apply_effect(negative = false):
	if not negative:
		if target_is_player:
			PlayerStats.armor_temp += added_armor
			PlayerStats.calculate_stats()
		elif target_is_monster:
			get_parent().get_parent().stats["armor"] += added_armor
	else:
		if target_is_player:
			PlayerStats.armor_temp -= added_armor
			PlayerStats.calculate_stats()
		elif target_is_monster:
			get_parent().get_parent().stats["armor"] -= added_armor
