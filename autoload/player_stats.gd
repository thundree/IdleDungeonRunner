extends Node

signal update_inventory
signal update_stats
signal update_gear_slot
signal unlocked_skill

var player_level = 1
var total_exp = 0
var base_exp_req = 150
var exp_multi = 2.2


var stats = {"hp": 100, "max_hp": 100, "phys_damage": 0, "magic_damage": 0, "armor": 0, "magic_res": 0, "crit_chance": 0.05,
			 "crit_multi": 1.5, "action_time": 0.3, "action_time_auto": 0.3, "action_time_manual": 0.1, "dot_damage_multi": 1,
			 "effect_duration_multi": 1, "status_resistance": 1, "tick_duration_multi": 1}

var stat_texts = {"max_hp": "Max HP", "phys_damage": "Physical Damage", "magic_damage": "Magic Damage", "armor": "Armor",
					"magic_res": "Magic Resistance", "crit_chance": "%Critical Strike Chance", "crit_multi": "%Critical Strike Multiplier",
					"action_time_auto": "$Action Time (Auto)", "action_time_manual": "$Action Time (Manual)", "all_skills_added": "# Levels to all Skills"}

var equipped_items = {"weapon1": null, "weapon2": null, "body_armor": null, "helmet": null, "boots": null}

var inventory = []
var level = 1

var item_stat_texts = {"phys_damage_increased": "$% Increased Physical Damage", "magic_damage_increased": "$% Increased Magic Damage",
				 "crit_chance_increased": "$% Increased Critical Strike Chance", "crit_multi_increased": "$% Increased Critical Strike Multiplier",
				 "crit_multi_added": "+$% to Critical Strike Multiplier", "all_skills_added": "$ to all Skills", "max_hp_added": "$ to Max Life", 
				 "armor_increased": "$% Increased Armor", "magic_res_increased": "$% Increased Magic Resistance", "armor_added": "+$ to Armor",
				 "magic_res_added": "+$ to Magic Resistance", "action_time_reduced": "$% reduced Action Time"}


#DAMAGE
var phys_damage_base = 5
var phys_damage_increased = 0.0
var phys_damage_added = 0

var magic_damage_base = 5
var magic_damage_increased = 0.0
var magic_damage_added = 0

var crit_chance_base = 0.05
var crit_chance_increased = 0.0
var crit_chance_added = 0.0

var crit_multi_base = 1.5
var crit_multi_increased = 0.0
var crit_multi_added = 0.0

#DEFENSE
var max_hp_base = 100
var max_hp_increased = 0.0
var max_hp_added = 0

var armor_base = 10
var armor_increased = 0.0
var armor_added = 0
var armor_temp = 0

var magic_res_base = 10
var magic_res_increased = 0.0
var magic_res_added = 0

#SECONDARY RESOURCE
var essence_base = 100
var essence_increased = 0.0
var essence_added = 0

#MISC
var action_time_auto_base = 0.3
var action_time_manual_base = 0.1
var action_time_reduced = 0.0

#SKILLS
var all_skills_added = 0

func calculate_stats():
	#DAMAGE
	stats.phys_damage = (phys_damage_base + phys_damage_added) * (1 + phys_damage_increased)
	stats.magic_damage = (magic_damage_base + magic_damage_added) * (1 + magic_damage_increased)
	stats.crit_chance = (crit_chance_base + crit_chance_added) * (1 + crit_chance_increased)
	stats.crit_multi = (crit_multi_base + crit_multi_added) * (1 + crit_multi_increased)
	#DEFENSE
	var hp_percent = stats.hp / stats.max_hp
	stats.max_hp = (max_hp_base + max_hp_added) * (1 + max_hp_increased)
	stats.hp = stats.max_hp * hp_percent
	stats.armor = (armor_base + armor_added) * (1 + armor_increased) + armor_temp
	stats.magic_res = (magic_res_base + magic_res_added) * (1 + magic_res_increased)
	#SECONDARY RESOURCE
	stats.essence = (essence_base + essence_added) * (1 + essence_increased)
	#MISC
	stats.action_time_auto = (action_time_auto_base) / (1 + action_time_reduced)
	stats.action_time_manual = (action_time_manual_base) / (1 + action_time_reduced)
	stats.all_skills_added = all_skills_added
	if CombatProcessor.auto_combat:
		stats.action_time = stats.action_time_auto
	else:
		stats.action_time = stats.action_time_manual
	emit_signal("update_stats")
	CombatProcessor.emit_signal("player_hp_updated")


func equip_item(item : Item):
	var slot_used = ""
	inventory.remove(inventory.find(item))
	if item.type == "weapon":
		if equipped_items["weapon1"] == null:
			equipped_items["weapon1"] = item
			slot_used = "weapon1"
		elif equipped_items["weapon2"] == null:
			equipped_items["weapon2"] = item
			slot_used = "weapon2"
		else:
			unequip_item("weapon1")
			equipped_items["weapon1"] = item
			slot_used = "weapon1"
	else:
		unequip_item(item.type)
		equipped_items[item.type] = item
		slot_used = item.type
	emit_signal("update_gear_slot", slot_used, item)
	item.equip()
	emit_signal("update_inventory")
	calculate_stats()


func unequip_item(slot):
	if equipped_items[slot] != null:
		equipped_items[slot].unequip()
		equipped_items[slot] = null
	emit_signal("update_gear_slot", slot, null)
	calculate_stats()


func add_to_inv(item):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			return
	inventory.append(item)
	emit_signal("update_inventory")


func check_level():
	if total_exp > base_exp_req * pow(level, exp_multi):
		level += 1
		print("Character leveled up to level " + str(level))
		SkillData.check_skill_unlocks()
		check_level()








