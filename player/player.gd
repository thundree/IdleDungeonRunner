extends AnimatedSprite
class_name Player

signal is_player
signal hp_updated

var stats = {"hp": 100, "max_hp": 100, "phys_damage": 0, "magic_damage": 0, "armor": 0, "magic_res": 0, "crit_chance": 0.05,
			 "crit_multi": 1.5, "action_time": 0.3, "action_time_auto": 0.3, "action_time_manual": 0.1, "dot_damage_multi": 1,
			 "effect_duration_multi": 1}



var mod_stats = {}


export var base_action_time_auto = 0.3
export var base_action_time_manual = 0.1

var skills_in_order = []
var dead = false
var can_be_attacked = true
var manual_combat_cd_multiplier = 5.0

func _ready():
	CombatProcessor.Player = self
	CombatProcessor.connect("entered_auto_combat", self, "_on_enter_auto_combat")
	CombatProcessor.connect("entered_manual_combat", self, "_on_enter_manual_combat")
	CombatProcessor.connect("entered_combat", self, "enter_combat")
	CombatProcessor.connect("exited_combat", self, "exited_combat")
	CombatProcessor.emit_signal("update_skills", export_skills())
	connect("hp_updated", CombatProcessor, "_on_player_hp_updated")
	play("run")


func take_damage(damage):
	if stats.hp - damage > 0:
		stats.hp -= damage
		emit_signal("hp_updated")
	elif stats.hp - damage <= 0:
		stats.hp = 0
		emit_signal("hp_updated")
		queue_free()


var used_skill =  false
func next_action():
	download_stats()
	used_skill = false
	for skill in $Skills.get_children():
		if skill.attack:
			used_skill = skill.try_to_use_skill(self, CombatProcessor.Enemy)
		elif skill.cast_on_self:
			used_skill = skill.try_to_use_skill(self, self)
		if used_skill:
			break
	start_action_timer()


func _on_ActionTimer_timeout():
	if CombatProcessor.in_combat:
		CombatProcessor.next_action_ready = true
		if CombatProcessor.auto_combat:
			next_action()


func start_action_timer():
	CombatProcessor.next_action_ready = false
	$ActionTimer.start(stats.action_time)


func enter_combat():
	download_stats()
	play("idle")
	if CombatProcessor.auto_combat:
		start_action_timer()


func exited_combat():
	speed_scale = 1
	play("run")


func _on_Player_animation_finished():
	if animation == "attack" or animation == "attack_alt":
		play("idle")


func _on_enter_manual_combat():
	for skill in $Skills.get_children():
		skill.cooldown /= manual_combat_cd_multiplier
	CombatProcessor.emit_signal("update_skills", export_skills())
	stats.action_time = stats.action_time_manual
	calculate_anim_speed()


func _on_enter_auto_combat():
	for skill in $Skills.get_children():
		skill.cooldown *= manual_combat_cd_multiplier
	CombatProcessor.emit_signal("update_skills", export_skills())
	stats.action_time = stats.action_time_auto
	if $ActionTimer.time_left == 0:
		start_action_timer()
	calculate_anim_speed()


func calculate_anim_speed():
	if CombatProcessor.in_combat:
		speed_scale = base_action_time_auto / stats.action_time


func export_skills():
	return $Skills.get_children()


func download_stats():
	PlayerStats.calculate_stats()
	stats = PlayerStats.stats
	calculate_anim_speed()
