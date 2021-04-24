extends Control

const StatLabel = preload("res://UI/item_inspector/stat_label.tscn")

var item : Item

var gear_slot = false
var gear_slot_name = ""

func update_stats():
	for child in $Panel/VBoxContainer/Stats/VBoxContainer.get_children():
		$Panel/VBoxContainer/Stats/VBoxContainer.remove_child(child)
		child.queue_free()
	for stat in item.stats:
		var stat_label = create_stat(stat)
		$Panel/VBoxContainer/Stats/VBoxContainer.add_child(stat_label)
	for child in $Panel/VBoxContainer/Implicit.get_children():
		$Panel/VBoxContainer/Implicit.remove_child(child)
		child.queue_free()
	for stat in item.implicit_stats:
		var implicit_stat_label = create_implicit_stat(stat)
		$Panel/VBoxContainer/Implicit.add_child(implicit_stat_label)


func create_stat(stat):
	var stat_label = StatLabel.instance()
	if "$%" in PlayerStats.item_stat_texts[stat]:
		stat_label.text = PlayerStats.item_stat_texts[stat].replace("$", str(item.stats[stat] * 100).pad_decimals(0))
	elif "$" in PlayerStats.item_stat_texts[stat]:
		stat_label.text = PlayerStats.item_stat_texts[stat].replace("$", str(item.stats[stat]))
	else:
		stat_label.text = PlayerStats.item_stat_texts[stat]
	return stat_label


func create_implicit_stat(stat):
	var stat_label = StatLabel.instance()
	if "$%" in PlayerStats.item_stat_texts[stat]:
		stat_label.text = PlayerStats.item_stat_texts[stat].replace("$", str(item.implicit_stats[stat] * 100).pad_decimals(0))
	elif "$" in PlayerStats.item_stat_texts[stat]:
		stat_label.text = PlayerStats.item_stat_texts[stat].replace("$", str(item.implicit_stats[stat]))
	else:
		stat_label.text = PlayerStats.item_stat_texts[stat]
	return stat_label


func update_name():
	$Panel/VBoxContainer/Name.text = item.item_name
	$Panel/VBoxContainer/iLevelType.text = "iLevel " + str(item.item_level) + " " + item.rarity.capitalize() + " " + item.base_item_name


func update_affixes():
	var final = ""
	for affix in item.affixes: 
		final += affix + " - "
	final.erase(len(final) -3, 3)
	$Panel/VBoxContainer/Affixes.text = final


func update_image():
	$Panel/VBoxContainer/Image/TextureRect.texture = load(item.image_path)


func update():
	if item != null:
		update_name()
		update_affixes()
		update_image()
		update_stats()
	if gear_slot:
		$Panel/VBoxContainer/HBoxContainer/Equip/Label.text = "UNEQUIP"


func _on_TextureButton_pressed():
	queue_free()


func _on_Equip_pressed():
	if gear_slot:
		PlayerStats.unequip_item(gear_slot_name)
	else:
		PlayerStats.equip_item(item)
	queue_free()
