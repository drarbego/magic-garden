extends Area2D


const HealingMint = preload("res://PlantTypes/HealingMint.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.increase_action_projectiles(HealingMint, 5)
