extends Node

signal update_skills

var skill_dict = {"unlocked": true, "level": 1, "exp": 0, "exp_multi": 2, "base_exp_req": 50}
var skills = {"Basic Attack": skill_dict.duplicate(), "Strong Attack": skill_dict.duplicate(),
			 "Armor Up": skill_dict.duplicate(), "Lacerate": skill_dict.duplicate()}

var skill_unlocks = {"Basic Attack": 1, "Strong Attack": 2, "Armor Up": 3, "Lacerate": 5}

var skill_tags = {"Basic Attack": ["phys", "attack"], "Strong Attack": ["phys", "attack"], "Armor Up": ["cast_on_self"], "Lacerate": ["phys", "attack"]}

var skill_textures = {"Basic Attack": "res://resources/skill_icons/Icon1.png",
					 "Strong Attack": "res://resources/skill_icons/Icon6.png",
					 "Armor Up": "res://resources/skill_icons/Icon21.png",
					 "Lacerate": "res://resources/skill_icons/Icon39.png"}

var skill_desc = {}


func update_skill(skill_name):
	if CombatProcessor.Player.get_node("Skills").has_node(skill_name.replace(" ", "")):
		var skill_node : Skill = CombatProcessor.Player.get_node("Skills").get_node(skill_name.replace(" ", ""))
		skill_node.level = skills[skill_name]["level"]
		print(skill_node.skill_name + " is now level " + str(skill_node.level))


func check_skill_unlocks():
	for skill in skill_unlocks:
		if skill_unlocks[skill] == PlayerStats.level:
			emit_signal("unlocked_skill", skill)


func get_skill_ui_exp(skill_name):
	var total_needed_exp = get_skill_exp_req(skill_name, skills[skill_name]["level"]) - \
							get_skill_exp_req(skill_name, skills[skill_name]["level"] - 1)
	var pseudo_current_exp = skills[skill_name]["exp"] - get_skill_exp_req(skill_name, skills[skill_name]["level"] - 1)
	return [pseudo_current_exp, total_needed_exp]


func get_skill_exp_req(skill_name, level):
	return skills[skill_name]["base_exp_req"] * pow(level, skills[skill_name]["exp_multi"]) + 10 * level


func check_skill_level(skill_name):
	var curr_level = skills[skill_name]["level"]
	if skills[skill_name]["exp"] > get_skill_exp_req(skill_name, skills[skill_name]["level"]):
		skills[skill_name]["level"] += 1
		print(skill_name + " leveled up! Level " + str(curr_level + 1))
		update_skill(skill_name)
		check_skill_level(skill_name)
