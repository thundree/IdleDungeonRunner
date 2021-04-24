extends Monster

var used_skill =  false
func next_action():
	for skill in $Skills.get_children():
		if skill.attack:
			used_skill = skill.try_to_use_skill(self, CombatProcessor.Player)
		elif skill.cast_on_self:
			used_skill = skill.try_to_use_skill(self, self)
			if used_skill:
				break
	$ActionTimer.start(action_time)
