extends Node

# IMPORTANT NOTE: You can't do get_node in AutoLoad, because this is a nodeless script
# it can't have children and can't do get_tree()
# ANY node can access this script
# tip: Signal names are usually past-tense verbs like "entered", "skill_activated", or "item_collected".

# Pattern: Inventory -> GUI (SlotContainer & ItemSlot)
# Inventory features:
# 1. Add item: players can add item to the inventory
# 2. Craft item (update and remove): players can craft item within the inventory
# 3. Inspect item: players can inspect item within the inventory (with a pop up window)
# 4. Drop item to characters: players can give items to NPCs or placing objects

signal extend_slot()
signal display_item_to_inventory(item_index, texture_path)

# var inventory_list = ["Lighter", "Magnifyer", "Bucket", null, null, null] # Test
var inventory_list = [null, null, null, null, null, null]

onready var texture_path

func extend_inv() -> void: # extending inventory slot
	# the function checks wether the inventory list contains all list without any null.
	if not null in inventory_list: # if there is no more null in the list
		inventory_list.push_back(null) # add 1 slot to the back of the list
		emit_signal("extend_slot")

func add_item(item_name: Node2D) -> void: # item_name: Node
	# add items to the inventory
	var itemName = item_name.get_name() # get the item name
	var itemIndex = inventory_list.find(null) # find null reference
	
	# always add item to the first slot.
	# if the first slot is not empty then we're adding the item to the next empty slot
	if itemIndex != -1:
		inventory_list[itemIndex] = itemName # set the added item to the first slot

	texture_path = ImportData.item_list[itemName]["texture-path"] # texture path for the added item
	
	# everytime we're adding a new item to the inventory, we're also checking wether we still have room or not
	extend_inv()
	# emit a signal and pass the item index and texture path to the display GUI
	emit_signal("display_item_to_inventory", itemIndex, texture_path) # checks wether the inventory is full or not
	
func get_craft_item(selected_item): # helper function, get craftable item
	print_debug(selected_item)
	var get_item_name = ImportData.item_list[selected_item]["craftable-item"]["combine-item-result"]
	return get_item_name
	
func craft_item(item_index, target_item_index): # item_index: index, target_item_index: index
	var new_item = get_craft_item(inventory_list[item_index]) # set the new_item as the target_item_index
	# update the inventory and display with the new item
	inventory_list[target_item_index] = new_item 
	texture_path = ImportData.item_list[new_item]["texture-path"]
	emit_signal("display_item_to_inventory", target_item_index, texture_path)
	remove_item(item_index) # remove the previous item (the selected item)
	
	return new_item
	
func remove_item(item_index):
	inventory_list[item_index] = null
	emit_signal("display_item_to_inventory", item_index, null)
	
func swap_item(item_index, target_item_index): # item_index: data[origin-item-index], target_item_index: data[target_item_index]
	
	var targetItem = inventory_list[target_item_index]
	var current_item = inventory_list[item_index]
	
	inventory_list[item_index] = targetItem
	inventory_list[target_item_index] = current_item
