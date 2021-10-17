extends Area2D


const HealingMint = preload("res://PlantTypes/HealingMint.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(str(HealingMint), 5)
