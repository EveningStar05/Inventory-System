extends Control

onready var item = get_parent() # item node

func _ready():
	$TextureButton.connect("pressed", self, "_on_TextureButton_pressed")

func _on_TextureButton_pressed():
	Inventory.add_item(item)
	item.queue_free()
