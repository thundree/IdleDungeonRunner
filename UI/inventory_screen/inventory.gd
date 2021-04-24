extends Control

const Stat = preload("res://UI/inventory_screen/stat/stat.tscn")
onready var stats = $VBoxContainer/Center/HBoxContainer/StatsBackground/VBoxContainer/ScrollContainer/VBoxContainer


func _ready():
	PlayerStats.connect("update_stats", self, "update_stats")
	PlayerStats.connect("update_gear_slot", self, "update_gear_slot")


func clear_inventory():
	for slot in get_tree().get_nodes_in_group("inventory_slots"):
		slot.item = null
		slot.update_slot()


func update_slots():
	clear_inventory()
	for item in PlayerStats.inventory:
		var slotted = false
		for slot in get_tree().get_nodes_in_group("inventory_slots"):
			if slot.item == null:
				slot.item = item
				slot.update_slot()
				slotted = true
				break


func update_gear_slot(slot_name, item):
	for slot in get_tree().get_nodes_in_group("gear_slots"):
		if slot.slot_name == slot_name:
			slot.item = item
			slot.update_slot()


func update_stats():
	for stat in stats.get_children():
		stats.remove_child(stat)
		stat.queue_free()
	for stat in PlayerStats.stat_texts:
		if PlayerStats.stats[stat] != 0:
			var _stat = Stat.instance()
			_stat.initialize(PlayerStats.stat_texts[stat], PlayerStats.stats[stat])
			stats.add_child(_stat)
