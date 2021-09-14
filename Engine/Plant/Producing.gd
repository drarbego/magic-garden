extends Node


func ready(plant):
	plant.get_node("ProductionTimer").set_wait_time(plant.production_wait_time)
	plant.get_node("ProductionTimer").start()

func on_InteractionDetector_body_entered(body, plant):
	if body is Character:
		if plant.produced:
			plant.give_product(body)
	elif body is WaterDrop:
		plant.receive_water()

func on_InteractionDetector_body_exited(body, _plant):
	if body is Character:
		body.do_interaction = FuncRef.new()

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

	if plant.needs_water:
		plant.get_node("AnimationPlayer").play("water")
	else:
		plant.get_node("AnimationPlayer").stop()
		plant.get_node("WaterDrop").visible = false
