extends Node2D

var temp = 0

var curr_scene = "Combat"

func move_camera(screen):
	$Camera2D.position = screen.position


func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		if temp == 2:
			switch_to_combat()
			temp = 0
		elif temp == 1:
			switch_to_skills()
			temp += 1
		else:
			switch_to_inventory()
			temp += 1


func switch_to_inventory():
	curr_scene = "Inventory"
	PlayerStats.emit_signal("update_inventory")
	move_camera(get_node("Inventory"))


func switch_to_skills():
	curr_scene = "Skills"
	SkillData.emit_signal("update_skills")
	move_camera(get_node("Skills"))

func switch_to_combat():
	curr_scene = "Combat"
	move_camera(get_node("Combat"))
