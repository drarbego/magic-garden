extends Node2D


func spawn_plant(plant):
	$Plants.add_child(plant)

func set_hud_items(items):
	var container = $HUD/Inventory/ScrollContainer/GridContainer
	for child in container.get_children():
		child.queue_free()

	for item in items:
		container.add_child(item)
