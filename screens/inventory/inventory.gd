extends Node2D


func _ready():
	PlayerStats.connect("update_inventory", self, "update_inventory_slots")


func update_inventory_slots():
	if get_tree().root.get_node("/root/Main").curr_scene == "Inventory":
		$Inventory.update_slots()
