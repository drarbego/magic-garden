extends Area2D


const WaterDropItem = preload("res://ItemTypes/WaterDropItem.tscn")
const MAX_AMOUNT = 5


func _on_WaterDispenser_body_entered(body):
	if body is Character:
		body.add_item_to_inventory(WaterDropItem, MAX_AMOUNT, MAX_AMOUNT)
