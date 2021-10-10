extends Area2D


const WaterDrop = preload("res://ProjectileTypes/WaterDrop.tscn")
const MAX_AMOUNT = 5


func _on_WaterDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(str(WaterDrop), MAX_AMOUNT, MAX_AMOUNT)
