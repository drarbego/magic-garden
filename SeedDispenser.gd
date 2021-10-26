extends Area2D


const FirePepperSeedItem = preload("res://ItemTypes/FirePepperSeedItem.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(FirePepperSeedItem, 5)
