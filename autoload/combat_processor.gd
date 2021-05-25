extends Node


signal entered_combat
signal exited_combat
signal monster_hp_updated
signal player_hp_updated
signal entered_auto_combat
signal entered_manual_combat
signal applied_effect


var Enemy
var Player
var CombatBottom
var in_combat = false

var auto_combat = true
var next_action_ready = true


func _ready():
	connect("exited_combat", self, "_on_exited_combat")


var test_items = true	# TESTING
func enter_combat():
	in_combat = true
	emit_signal("entered_combat")
	if test_items:
		test_items = false
		for i in range(1, 121, 10):
			var new_item1 = ItemGenerator.make_test_item("body_armor", i, "uncommon")
			var new_item2 = ItemGenerator.make_test_item("weapon", i, "rare")
			var new_item3 = ItemGenerator.make_test_item("helmet", i, "uncommon")
			var new_item4 = ItemGenerator.make_test_item("boots", i, "uncommon")
			PlayerStats.add_to_inv(new_item1)
			PlayerStats.add_to_inv(new_item2)
			PlayerStats.add_to_inv(new_item3)
			PlayerStats.add_to_inv(new_item4)



func apply_effect(attacker, target, effect, effect_args : Array, effect_duration : float):
	var eff = effect.instance()
	if effect_duration < 0:
		effect_duration = INF
	eff.initialize(attacker, target, effect_args, effect_duration)
	emit_signal("applied_effect", target, eff)


func process_damage(damage, attacker, target, type):
	var crit_roll = (randf() < attacker.stats.crit_chance)
	if crit_roll:
		damage *= attacker.stats.crit_multi
	if type == "phys":
		damage = 10 * (damage * damage) / (target.stats.armor + 10 * damage)
	elif type == "magic":
		damage = 10 * (damage * damage) / (target.stats.magic_res + 10 * damage)
	target.take_damage(damage)
	return damage

func process_skill_exp(skill_name):
	if Player != null and Enemy != null:
		var xp = 50 * PlayerStats.player_level * Enemy.level
		SkillData.skills[skill_name]["exp"] += xp
		SkillData.check_skill_level(skill_name)
		PlayerStats.total_exp += xp
		PlayerStats.check_level()
		SkillData.emit_signal("update_skills", CombatProcessor.Player.export_skills())


func process_dot_damage(damage, tick_duration, attacker, target):
	var new_damage = damage * attacker.stats["dot_damage_multi"]
	new_damage /= target.stats["status_resistance"]
	var new_tick_duration = tick_duration * attacker.stats["tick_duration_multi"]
	return [new_damage, new_tick_duration]


func damage_enemy(damage):
	var end_damage = process_damage(damage, Player, Enemy, null)
	Enemy.take_damage(end_damage)


func _on_monster_hp_updated():
	emit_signal("monster_hp_updated")


func _on_player_hp_updated():
	emit_signal("player_hp_updated")


func _on_exited_combat():
	Player.stats["hp"] = Player.stats["max_hp"]
	emit_signal("player_hp_updated")
	ZoneInfo.zone_floor += 1


func enter_manual_combat():
	auto_combat = false
	emit_signal("entered_manual_combat")


func enter_auto_combat():
	auto_combat = true
	emit_signal("entered_auto_combat")


func _on_player_used_skill(skill_name):
	CombatBottom.use_skill(skill_name)
