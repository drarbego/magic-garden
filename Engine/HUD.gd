extends CanvasLayer


func _on_ShowInventoryButton_pressed():
	$Control/Inventory.set_visible(!$Control/Inventory.visible)
