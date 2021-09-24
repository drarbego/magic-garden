extends Area2D


const FirePepper = preload("res://PlantTypes/FirePepper.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.increase_action_projectiles(FirePepper, 5)
