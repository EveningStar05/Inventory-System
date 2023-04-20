extends Node

# JSON file structure:
#	{
#   "Bucket": {
#       "texture-path": "res://Inventory_Items/bucket.png",
#      "craftable-item": {
#          "item-name": "Light-Bulb",
#          "combine-item-result": "Magnifyer"
#       },
#   },
#   "Light-Bulb" :{
#       "texture-path": "res://Inventory_Items/bulb.png",
#       "craftable-item": {
#           "item-name": "Bucket",
#           "combine-item-result": "Magnifyer"
#       },
#   },
#	...
#}

var item_list

# read and load json file here
func _ready():
	var file = File.new()
	file.open("res://item-list.json", file.READ)
	var item_json = JSON.parse(file.get_as_text())
	file.close()
	item_list = item_json.result
