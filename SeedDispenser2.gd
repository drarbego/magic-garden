extends Area2D


const HealingMintSeedItem = preload("res://ItemTypes/HealingMintSeedItem.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(HealingMintSeedItem, 5)
