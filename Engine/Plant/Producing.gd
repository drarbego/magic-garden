extends Node


func ready(plant):
	plant.get_node("ProductionTimer").set_wait_time(plant.production_wait_time)
	plant.get_node("ProductionTimer").start()

func on_HitBox_body_entered(body, plant):
	if body is Projectile and body.has_method("on_impact"):
		body.on_impact(plant)

func on_HitBox_body_exited(_body, _plant):
	pass

func on_CharacterDetector_body_entered(body, plant):
	if body is Character:
		body.near_plants[plant.get_instance_id()] = plant

func on_CharacterDetector_body_exited(body, plant):
	if body is Character:
		body.near_plants.erase(plant.get_instance_id())

func on_ProductionTimer_timeout(plant):
	plant.produced = true

func process(_delta, plant):
	plant.get_node("ProducedParticles").emitting = plant.produced
