extends CanvasLayer


func _unhandled_input(event):
	if event.is_action_pressed("toggle_hud"):
		self.toggle_hud()

func toggle_hud():
	$Control/Inventory.set_visible(!$Control/Inventory.visible)
