extends TextureRect

signal inspect_item(slot_index)

# var can_craft_item = false

func _ready():
	Inventory.connect("display_item_to_inventory", self, "_on_display_item_to_inventory") # connect Inventory to Display
		
func _gui_input(event): # detecting mouse clicks, for inspecting item
	var item_index = get_index()
	# var event_local = make_input_local(event)
	if event is InputEventMouseButton:
		if event.doubleclick: # double click item to inspect
			emit_signal("inspect_item", item_index)
	
func _on_display_item_to_inventory(index, texture_path): # sets the display
	#var slot_list = get_parent().get_children()
	var slot_list = get_tree().get_nodes_in_group("slots")
	if texture_path != null: # craft and add item
		var load_texture = load(texture_path)
		#slot_list[index].set_texture(load_texture)
		#print(slot_list)
		slot_list[index].set_texture(load_texture)
		#slot_list[index].texture = load(texture_path) # load the texture while the scene is running.
	else: # removing item from slot display
		slot_list[index].texture = texture_path

func get_drag_data(_position: Vector2): # get the selected item data
	var data = {} # passing the data to the other 2 function
	var get_current_index = get_index()

	data["origin_node"] = self
	data["origin_node_index"] = get_current_index
	
	if self != null and self.texture != null: # if the slot is not empty
#		data["origin_node"] = self
#		data["origin_node_index"] = get_current_index
		data["origin-item-name"] = Inventory.inventory_list[get_current_index]
		data["origin_texture"] = texture
		
		# add a new node for drag preview
		#var drag_texture = TextureRect.new() # creating a new node on runtime
		#drag_texture.expand = true
		#drag_texture.texture = texture # set the texture to whatever item is being added in the inventory
		#drag_texture.rect_size = Vector2(95, 95)
		# set the item to the middle of mouse position, so what we're doing here is add a Control node
		# and set the position of the item relative to the mouse cursor.
		
		var drag_scene = preload("res://Objects/item-slot-drag-preview.tscn").instance()
		drag_scene.expand = true
		drag_scene.texture = texture
		drag_scene.rect_size = Vector2(95, 95)
		drag_scene.set_name(data["origin-item-name"]) # test
		 
		var control_node = Control.new()
		control_node.add_child(drag_scene)
		drag_scene.rect_position = -0.5 * drag_scene.rect_size
		set_drag_preview(control_node)
		
	else:
		#data["origin_node"] = self
		#data["origin_node_index"] = get_current_index
		data["origin-item-name"] = null
		data["origin_texture"] = texture
	
	return data # can return self or data (passing the current info the the other 2 function)

func can_drop_data(_position, data): # checks wether this item can be drop at this particular slot
	
	var target_slot = self
	var target_index = get_index()

	data["target_slot"] = target_slot
	data["target_slot_index"] = target_index

	if target_slot.texture == null: # if the target slot is empty, we're moving the item. TODO: Change this to checking if data.name is null
		data["target_item_name"] = null
		data["target_texture"] = texture 
	else:
		#data["target_slot"] = target_slot
		#data["target_slot_index"] = target_index
		data["target_item_name"] = Inventory.inventory_list[target_index] # set the target name from the inventory list
		data["target_texture"] = texture
		
	if ImportData.item_list.keys().has(data["origin-item-name"]): # if the draggable data exist in the dictionary
		if ImportData.item_list[data["origin-item-name"]]["craftable-item"]["item-name"] == data["target_item_name"]:# if the drag data is equal to the target item.
			#can_craft_item = true
			return true
		else:
			#can_craft_item = false
			return false
	#return true
	
func drop_data(_position, data): # drop the item to the slot
	if data["target_slot"].texture == null: # if the next slot is empty we are moving the item
		texture = data["origin_texture"] # set the target slot to the selected item texture
		data["origin_node"].texture = null # then reset the previous slot texture to null, because we're just moving the item
	else: # swapping the item here
		texture = data["origin_texture"]
		data["origin_node"].texture = data["target_texture"]
		
	# crafting item: checks wether the target item is craftable with the selected item.
	#if can_craft_item:	
	var new_item = Inventory.craft_item(data["origin_node_index"], data["target_slot_index"]) # get the new item name
	# update the new item to the data dict
	data["target_item_name"] = new_item
	data["target_texture"] = texture
	#else:
	#	print("You can't craft this item!")
		# Inventory.swap_item(data["origin_node_index"], data["target_slot_index"]) # when the item is not craftable we're swapping it.

	print("======== DROP DATA ========")
	print("origin item: ", data["origin-item-name"])
	print("target item: ", data["target_item_name"])
	print(data)
	print(Inventory.inventory_list)
	
# mouse exited while dragging an item
# func _on_Background_mouse_exited():
#	if Input.is_action_pressed("click"):
#		return true
