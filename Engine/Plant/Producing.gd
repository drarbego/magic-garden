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

func on_CharacterDetector_body_exited(character, plant):
	character.near_plants.erase(plant.get_instance_id())

func on_ProductionTimer_timeout(plant):
	plant.produced = true

func process(delta, plant):
	plant.get_node("ProducedParticles").emitting = plant.produced
	var energy_delta = (
		-plant.energy_increase_per_sec if plant.needs_water else +plant.energy_increase_per_sec
	) * delta
	plant.energy = clamp(
		plant.energy + energy_delta,
		0.0,
		plant.MAX_ENERGY
	)
