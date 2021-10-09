extends Node

var current_plant: Object = null
const EATING_DISTANCE = 42
const SPEED = 100

func physics_process(delta, enemy):
	enemy.get_node("Label").set_text("eating")
	if not self.current_plant:
		if not enemy.plants_to_eat:
			enemy.current_state = enemy.get_node("States/Wandering")
			return

		self.current_plant = enemy.plants_to_eat.pop_front()

	if not is_instance_valid(self.current_plant):
		self.current_plant = null
		return

	if enemy.position.distance_to(self.current_plant.position) <= EATING_DISTANCE:
		self.current_plant.queue_free()
		self.current_plant = null
	else:
		enemy.move_and_slide(
			enemy.position.direction_to(self.current_plant.position) * SPEED
		)

func on_VisionArea_body_entered(body, enemy):
	if body is Character:
		enemy.current_state = enemy.get_node("States/Attacking")
	if body is Plant:
		enemy.plants_to_eat.append(body)
		enemy.current_state = enemy.get_node("States/Eating")

func on_VisionArea_body_exited(body, enemy):
	pass
