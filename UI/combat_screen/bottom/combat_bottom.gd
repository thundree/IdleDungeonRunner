extends Control

const EffectIcon = preload("res://UI/combat_screen/effect_icon/effect_icon.tscn")

onready var player_hp_bar = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar
onready var player_hp_value = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar/HPValue
onready var player_hp_tween = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar/Tween


func _ready():
	CombatProcessor.CombatBottom = self
	CombatProcessor.connect("entered_combat", self, "init")
	CombatProcessor.connect("player_hp_updated", self, "update_player_hp")
	CombatProcessor.connect("update_skills", self, "update_skills")
	CombatProcessor.connect("applied_effect", self, "apply_effect")


func init():
	update_player_hp()


func update_player_hp():
	player_hp_tween.interpolate_property(player_hp_bar, "value", player_hp_bar.value,
					 CombatProcessor.Player.stats.hp / CombatProcessor.Player.stats.max_hp, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	player_hp_tween.start()
	player_hp_value.text = str(int(CombatProcessor.Player.stats.hp)) + " HP"


func update_skills(skills):
	for skill_icon in get_tree().get_nodes_in_group("skills"):
		skill_icon.skill = null
	for skill in skills:
		for skill_icon in get_tree().get_nodes_in_group("skills"):
			if skill_icon.skill == null:
				skill_icon.skill = skill
				skill_icon.update_skill()
				break


func use_skill(skill_name):
	for skill in get_tree().get_nodes_in_group("skills"):
		if skill.skill != null:
			if skill.skill.skill_name == skill_name:
				skill.use_skill()


func apply_effect(target, effect):
	if target.has_signal("is_player"):
		var new_effect = EffectIcon.instance()
		new_effect.initialize(effect)
		$VBoxContainer/Effects.add_child(new_effect)
