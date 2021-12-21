extends Node


func ready(plant):
	plant.get_node("ProductionTimer").set_wait_time(plant.production_wait_time)
	plant.get_node("ProductionTimer").start()

func on_HitBox_body_entered(body, plant):
	if body is Projectile:
		plant.handle_impact(body)

func on_HitBox_body_exited(_body, _plant):
	pass

func on_CharacterDetector_body_entered(character, plant):
	character.near_plants[plant.get_instance_id()] = plant
	character.increase_magic_type(plant.magic_type)

func on_CharacterDetector_body_exited(character, plant):
	character.near_plants.erase(plant.get_instance_id())
	character.stop_increasing_magic_type(plant.magic_type)

func on_ProductionTimer_timeout(plant):
	plant.produced = true

func process(_delta, plant):
	plant.get_node("ProducedParticles").emitting = plant.produced
