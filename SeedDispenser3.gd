extends Area2D


const ElectricStarSeedItem = preload("res://ItemTypes/ElectricStarSeedItem.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(ElectricStarSeedItem, 5)
