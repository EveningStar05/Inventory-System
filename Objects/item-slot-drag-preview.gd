extends TextureRect

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("release")
