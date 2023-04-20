extends GridContainer

# move this script to inventory-script

func _ready():
	Inventory.connect("extend_slot", self, "_on_extend_slot")
	
func _on_extend_slot():
	# creating a new TextureRect node everytime extending the inventory slot.
	var script = preload("res://Scripts/Item-slot.gd") # preload the script
	var new_slot = TextureRect.new()
	# TextureRect settings
	new_slot.expand = true
	new_slot.rect_min_size = Vector2(95, 95)
	new_slot.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	new_slot.set_script(script)
	new_slot.set_name("Slot" + str(Inventory.inventory_list.size())) # set the name to Slot-n
	
	self.columns += 1
	add_child(new_slot)
