extends Area2D


const WaterDrop = preload("res://ProjectileTypes/WaterDrop.tscn")


func _on_WaterDispenser_body_entered(body):
	if body is Character:
		body.increase_action_projectiles(WaterDrop, 5.0)
