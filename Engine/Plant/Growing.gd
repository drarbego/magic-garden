extends Node


func ready(plant):
	plant.get_node("GrowthTimer").set_wait_time(plant.growth_wait_time)
	plant.get_node("GrowthTimer").start()

func on_HitBox_body_entered(body, plant):
	if body is Projectile:
		plant.handle_impact(body)

func on_HitBox_body_exited(_body, _plant):
	pass

func on_CharacterDetector_body_entered(body, plant):
	body.near_plants[plant.get_instance_id()] = plant

func on_CharacterDetector_body_exited(body, plant):
	body.near_plants.erase(plant.get_instance_id())

func on_GrowthTimer_timeout(plant):
	plant.get_node("PopEffect").play()
	plant.get_node("PopParticles").set_emitting(true)

	plant.stage += 1
	plant.growth_wait_time *= plant.growth_wait_scalar
	plant.update_graphics()

	if plant.stage == plant.GROWTH_STAGES_COUNT - 1:
		plant.change_state(plant.get_node("States/Producing"))
	else:
		plant.get_node("GrowthTimer").set_wait_time(plant.growth_wait_time)
		plant.get_node("GrowthTimer").start()
