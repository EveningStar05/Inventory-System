extends Control

onready var pop_up_window = preload("res://Item_Description/Item-description-base.tscn") # pop up window scene

# Nodes
onready var main_node = get_parent() # World
onready var panel = get_node("Background")
onready var gridcontainter = get_node("Background/ScrollContainer/GridContainer")
onready var scroll_container = get_node("Background/ScrollContainer")
onready var next_button = get_node("Background/Next")
onready var prev_button = get_node("Background/Previous")
onready var slot_item = get_tree().get_nodes_in_group("slots")

func _ready():
	panel.hide()
	Inventory.connect("extend_slot", self, "_on_extend_slot")
	for slots in slot_item:
		slots.connect("inspect_item", self, "_on_Slot_inspect_item")
		
# Extend inventory slot
func _on_extend_slot() -> void:
	
	var script = load("res://Scripts/Item-slot.gd") # preload the script
	var new_slot = TextureRect.new()
	
	# TextureRect settings
	new_slot.set_script(script)
	new_slot.set_name("Slot" + str(Inventory.inventory_list.size())) # set the name to Slot-n
	new_slot.expand = true
	new_slot.rect_min_size = Vector2(95, 95)
	new_slot.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	
	new_slot.add_to_group("slots")
	gridcontainter.columns += 1
	gridcontainter.add_child(new_slot)
	new_slot.connect("inspect_item", self, "_on_Slot_inspect_item") # connect the new node to the signal

# Inspect item on inventory
func _on_Slot_inspect_item(slot_index: int):
	var select_item = Inventory.inventory_list[slot_index] # select the item to inspect from inventor
	
	if select_item != null:
		var item_description = ImportData.item_list[select_item]["description"]
		# instancing the scene
		var window_scene = pop_up_window.instance()
		main_node.add_child(window_scene)
		
		# set the item data here
		window_scene.get_node("PanelContainer/TextureRect/Label").set_text(select_item)
		window_scene.get_node("PanelContainer2/RichTextLabel").bbcode_text = item_description[0] # set the item description
		window_scene.get_node("PanelContainer/TextureRect").texture = load(ImportData.item_list[select_item]["texture-path"]) # set the item texture)
		
# Toggle button
func _on_ToggleButton_toggled(button_pressed)-> void:
	if button_pressed:
		panel.show()
	else:
		panel.hide()

# scroll button
# Note: Scrollbar is hidden.
func _on_Next_pressed() -> void:
	scroll_container.scroll_horizontal += 95
	
func _on_Previous_pressed() -> void:
	scroll_container.scroll_horizontal -= 95
