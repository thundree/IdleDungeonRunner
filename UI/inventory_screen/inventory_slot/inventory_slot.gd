extends TextureRect

const base_b = preload("res://resources/gui_images/Frame.png")
const common_b = preload("res://resources/gui_images/Frame_Common.png")
const uncommon_b = preload("res://resources/gui_images/Frame_Rare.png")
const rare_b = preload("res://resources/gui_images/Frame_Legendary.png")
const ItemInspector = preload("res://UI/item_inspector/item_inspector.tscn")

var item : Item = null


func update_slot():
	if item == null:
		texture = base_b
		$TextureButton.texture_normal = null
	else: 
		texture = get(item.rarity + "_b")
		$TextureButton.texture_normal = load(item.image_path)


func _on_TextureButton_pressed():
	add_item_inspector()


func add_item_inspector():
	if item != null:
		var item_inspector = ItemInspector.instance()
		item_inspector.item = item
		item_inspector.update()
		get_tree().root.add_child(item_inspector)
		item_inspector.rect_position = get_tree().root.get_node("/root/Main/Inventory").position
