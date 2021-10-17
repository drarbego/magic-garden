extends Area2D


const FirePepper = preload("res://PlantTypes/FirePepper.tscn")

func _on_SeedDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(str(FirePepper), 5)
