extends Node2D


# todo move this to another class or rename it
func spawn_plant(plant):
	$Plants.add_child(plant)

func add_item_to_hud(item):
	$HUD/HBoxContainer.add_child(item)
