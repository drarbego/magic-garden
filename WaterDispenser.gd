extends Area2D

func _on_WaterDispenser_body_entered(body):
	if body is Character:
		body.has_water = true
