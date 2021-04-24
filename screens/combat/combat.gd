extends Node2D

const Bandit = preload("res://monsters/bandit/bandit.tscn")

var screen_width = 1080
var screen_height = 1920
var screen_center_x = 540
var padding_bottom = 900
var padding_top = 600
var scale_value = 1
var global_speed = 300


func spawn_enemy():
	var bandit = Bandit.instance()
	$Enemy.add_child(bandit)
	bandit.position = Vector2(screen_center_x, -500)
	bandit.scale = Vector2(0.25, 0.25)


func _ready():
	measure_screen()
	$Player/Player.position = Vector2(screen_center_x, screen_height / scale_value - padding_bottom)
	$Map/Image1.position.x = screen_center_x
	$Map/Image2.position.x = screen_center_x
	CombatProcessor.emit_signal("update_skills", $Player/Player.export_skills())
	spawn_enemy()


func measure_screen():
	screen_height = get_viewport().size.y
	screen_width = get_viewport().size.x
	scale_value = screen_width / 1080
	scale = Vector2(scale_value, scale_value)
	screen_center_x = (screen_width / scale_value) / 2
	$CombatTop.rect_size.x = 1080
	$CombatBottom.rect_size.x = 1080


func _on_monster_died():
	CombatProcessor.Enemy = null
	CombatProcessor.in_combat = false
	CombatProcessor.emit_signal("exited_combat")
	spawn_enemy()


var f2_on_top = true
var f1_on_top = false


func _process(delta):
	if not CombatProcessor.in_combat:
		move_map(delta)
		move_enemy(delta)


func move_map(delta):
	if f2_on_top:
		$Map/Image1.position = $Map/Image1.position.move_toward(Vector2(screen_center_x, 3520), global_speed * delta)
		$Map/Image2.position = $Map/Image2.position.move_toward(Vector2(screen_center_x, 320), global_speed * delta)
		if $Map/Image1.position == Vector2(screen_center_x, 3520):
			$Map/Image1.position = Vector2(screen_center_x, -2880)
			f1_on_top = true
			f2_on_top = false
	elif f1_on_top:
		$Map/Image2.position = $Map/Image2.position.move_toward(Vector2(screen_center_x, 3520), global_speed * delta)
		$Map/Image1.position = $Map/Image1.position.move_toward(Vector2(screen_center_x, 320), global_speed * delta)
		if $Map/Image2.position == Vector2(screen_center_x, 3520):
			$Map/Image2.position = Vector2(screen_center_x, -2880)
			f2_on_top = true
			f1_on_top = false


func move_enemy(delta):
	if CombatProcessor.Enemy.position != Vector2(screen_center_x, padding_top):
		CombatProcessor.Enemy.position = CombatProcessor.Enemy.position.move_toward(Vector2(screen_center_x, padding_top), global_speed * delta)
	else:
		CombatProcessor.enter_combat()
