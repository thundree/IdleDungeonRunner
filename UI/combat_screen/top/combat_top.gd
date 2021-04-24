extends Control

const EffectIcon = preload("res://UI/combat_screen/effect_icon/effect_icon.tscn")

onready var zone_info = $Main/HigherBackground/Background/VBoxContainer/Background/ZoneInfo
onready var monster_name = $Main/LowerBackground/VBoxContainer/MonsterInfo/VBoxContainer/Name
onready var monster_modifiers = $Main/LowerBackground/VBoxContainer/MonsterInfo/VBoxContainer/Modifiers
onready var monster_hp_bar = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP
onready var monster_hp_value = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP/HPValue
onready var monster_hp_tween = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP/Tween


func _ready():
	CombatProcessor.connect("entered_combat", self, "init")
	CombatProcessor.connect("monster_hp_updated", self, "update_monster_hp")
	CombatProcessor.connect("applied_effect", self, "apply_effect")
	CombatProcessor.connect("exited_combat", self, "on_exited_combat")


func init():
	update_zone_info()
	update_monster_info()
	init_monster_hp()


func update_zone_info():
	zone_info.text = ZoneInfo.zone_name + " : Floor " + str(ZoneInfo.zone_floor)


func update_monster_info():
	monster_name.text = CombatProcessor.Enemy.monster_name
	update_monster_modifiers()


func update_monster_modifiers():
	var text = ""
	for prefix in CombatProcessor.Enemy.prefixes:
		text += prefix + " - "
	for suffix in CombatProcessor.Enemy.suffixes:
		text += suffix + " - "
	text.erase(text.length() - 3, 3)
	monster_modifiers.text = text


func init_monster_hp():
	monster_hp_bar.max_value = CombatProcessor.Enemy.stats.max_hp
	monster_hp_bar.value = monster_hp_bar.max_value
	monster_hp_value.text = str(int(CombatProcessor.Enemy.stats.hp)) + " HP"


func update_monster_hp():
	monster_hp_tween.interpolate_property(monster_hp_bar, "value", monster_hp_bar.value,
					 CombatProcessor.Enemy.stats.hp, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	monster_hp_tween.start()
	monster_hp_value.text = str(int(CombatProcessor.Enemy.stats.hp)) + " HP"


func apply_effect(target, effect):
	if target.has_signal("is_monster"):
		var new_effect = EffectIcon.instance()
		new_effect.initialize(effect)
		$Main/Effects.add_child(new_effect)


func on_exited_combat():
	for effect in $Main/Effects.get_children():
		$Main/Effects.remove_child(effect)
		effect.queue_free()



























