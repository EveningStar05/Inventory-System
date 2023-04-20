extends Control

onready var pop_up_window = preload("res://Item_Description/Item-description-base.tscn") # pop up window scene

# Nodes
onready var main_node = get_parent() # World
onready var panel = get_node("Background")
onready var gridcontainter = get_node("Background/ScrollContainer/GridContainer")
onready var scroll_container = get_node("Background/ScrollContainer")
onready var next_button = get_node("Background/Next")
onready var prev_button = get_node("Background/Previous")
onready var grid_container_children = gridcontainter.get_children()

func _ready():
	panel.hide()
	Inventory.connect("extend_slot", self, "_on_extend_slot")
	for slots in grid_container_children:
		slots.connect("inspect_item", self, "_on_Slot_inspect_item")
		
# Extend inventory slot
func _on_extend_slot():
	
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
func _on_Slot_inspect_item(slot_index):
	var select_item = Inventory.inventory_list[slot_index] # select the item to inspect from inventor
	
	if select_item != null:
		var item_description = ImportData.item_list[select_item]["description"]
		# instancing the scene
		var window_scene = pop_up_window.instance()
		main_node.add_child(window_scene)
		
		# set the item data here
		window_scene.get_node("TextureRect/Label").set_text(select_item) # set the item name
		window_scene.get_node("MarginContainer/RichTextLabel").set_text(item_description[0]) # set the item description
		window_scene.get_node("TextureRect").texture = load(ImportData.item_list[select_item]["texture-path"]) # set the item texture)
		
# Toggle button
func _on_ToggleButton_toggled(button_pressed):
	if button_pressed:
		panel.show()
	else:
		panel.hide()

# scroll button		
func _on_Next_pressed():
	scroll_container.scroll_horizontal += 95
	
func _on_Previous_pressed():
	scroll_container.scroll_horizontal -= 95
