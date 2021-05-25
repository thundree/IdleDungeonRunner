extends Node2D


func _ready():
	SkillData.connect("update_skills", self, "update_skills")


func update_skills(skills):
	if get_tree().root.get_node("/root/Main").curr_scene == "Skills":
		$Skills.update()
