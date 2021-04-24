extends Control

const SkillPanel = preload("res://UI/skills_screen/skill_panel/skill_panel.tscn")

var added_skills = []


func add_skill(skill):
	var skill_panel = SkillPanel.instance()
	$VBoxContainer/Skills/VBoxContainer/Container/Skills.add_child(skill_panel)
	skill_panel.initialize(skill)
	added_skills.append(skill)


func update():
	for skill in PlayerStats.skill_unlocks:
		if PlayerStats.level >= PlayerStats.skill_unlocks[skill]:
			if skill in added_skills:
				for child in $VBoxContainer/Skills/VBoxContainer/Container/Skills.get_children():
					if child.skill_name == skill:
						child.update()
						break
			else:
				add_skill(skill)















