extends Effect

var tick_damage = 0.0

func initialize(attacker, target, args, _duration):
	var damage_info = CombatProcessor.process_dot_damage(args[0], base_tick_duration, attacker, target)
	tick_damage = damage_info[0]
	tick_duration = damage_info[1]
	duration = _duration
	update_duration(attacker, target)
	add_self_to_parent(target)


func apply_effect(negative = false):
	get_parent().get_parent().take_damage(tick_damage)
