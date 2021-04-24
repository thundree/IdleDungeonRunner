extends TextureRect


var skill = null
var cooldown = 10.0
var new_cooldown = 10.0
var auto_combat = false
var should_update_cooldown = false


func _ready():
	CombatProcessor.connect("entered_combat", self, "set_enabled")
	CombatProcessor.connect("exited_combat", self, "set_disabled")
	update_skill()


func _process(delta):
	$CooldownValue.text = "%3.1f" % $Cooldown.time_left
	$CooldownTexture.value = int(($Cooldown.time_left / cooldown) * 100)


func update_skill():
	if skill != null:
		$SkillIcon.texture_normal = load(skill.icon_path)
		if $Cooldown.time_left == 0:
			cooldown = skill.cooldown
			$Cooldown.wait_time = cooldown
		elif $Cooldown.time_left > 0:
			new_cooldown = skill.cooldown
			should_update_cooldown = true
		$SkillIcon.disabled = false
	elif skill == null:
		$SkillIcon.texture_normal = load("res://resources/skill_icons/lock.png")
		$SkillIcon.disabled = true


func use_skill():
	$SkillIcon.disabled = true
	$Cooldown.start()
	$CooldownValue.show()


var used_skill = false
func player_use_skill():
	if CombatProcessor.Player != null:
		for pskill in CombatProcessor.Player.get_node("Skills").get_children():
			if pskill.skill_name == skill.skill_name:
				if pskill.attack:
					used_skill = pskill.try_to_use_skill(CombatProcessor.Player, CombatProcessor.Enemy)
				elif pskill.cast_on_self:
					used_skill = pskill.try_to_use_skill(CombatProcessor.Player, CombatProcessor.Player)
					if used_skill:
						CombatProcessor.Player.start_action_timer()
	else:
		print("Player is ded :(")


func set_enabled():
	$SkillIcon.disabled = false


func set_disabled():
	$SkillIcon.disabled = true


func _on_SkillIcon_pressed():
	if not CombatProcessor.auto_combat and CombatProcessor.in_combat:
		player_use_skill()


func _on_Cooldown_timeout():
	$CooldownValue.hide()
	$SkillIcon.disabled = false
	if should_update_cooldown:
		cooldown = new_cooldown
		should_update_cooldown = false
		$Cooldown.wait_time = cooldown
