extends AnimatedSprite
class_name Monster

signal is_monster
signal hp_updated
signal monster_died

export var base_name =  "Monster"
export var monster_name = "Monster"
export var action_time = float(1)

var prefixes = []
var suffixes = []

var dead = false
var can_be_attacked = true

var stats = {"hp": 100, "max_hp": 100, "phys_damage": 0, "magic_damage": 0, "armor": 0, "magic_res": 0, "crit_chance": 0.05,
			 "crit_multi": 1.5, "action_time": 0.3, "dot_damage_multi": 1, "effect_duration_multi": 1, "status_resistance": 1,
			 "tick_duration_multi": 1, "level": 1}

var added_stats = {"armor": 0}


func _ready():
	play("idle")
	init_modifiers()
	make_name()
	update_skill_cooldowns()
	CombatProcessor.Enemy = self
	connect("monster_died", get_parent().get_parent(), "_on_monster_died")
	connect("hp_updated", CombatProcessor, "_on_monster_hp_updated")
	CombatProcessor.connect("entered_combat", self, "enter_combat")


func die():
	dead = true
	can_be_attacked = false
	$Hitbox/CollisionShape2D.disabled = true
	play("die")


func init_modifiers():
	for mod in $Modifiers.get_children():
		if mod.prefix == true:
			prefixes.append(mod.mod_name)
		if mod.suffix == true:
			suffixes.append(mod.mod_name)


func make_name():
	monster_name = base_name
	if not prefixes.empty():
		var prefix = prefixes[randi() % len(prefixes)]
		monster_name = prefix + " " + base_name
	if not suffixes.empty():
		var suffix = suffixes[randi() % len(suffixes)]
		monster_name += " " + suffix

func set_hp(value):
	stats.hp = value
	emit_signal("hp_updated")


func take_damage(damage):
	if stats.hp - damage > 0:
		stats.hp -= damage
	elif stats.hp - damage <= 0:
		stats.hp = 0
		die()
	emit_signal("hp_updated")


func _on_Monster_animation_finished():
	if animation == "attack":
		play("idle")
	elif animation == "die":
		emit_signal("monster_died")
		queue_free()


func set_attacker_and_target():
	pass


func start_action_timer():
	$ActionTimer.start(action_time)


func _on_ActionTimer_timeout():
	if CombatProcessor.in_combat:
		next_action()


func next_action():
	pass


func enter_combat():
	set_hp(stats.max_hp)
	start_action_timer()


func update_skill_cooldowns():
	for skill in $Skills.get_children():
		skill.cooldown *= 3
