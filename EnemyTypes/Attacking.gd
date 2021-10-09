extends Node

func physics_process(delta, enemy):
	enemy.get_node("Label").set_text("attacking")
	pass

func on_VisionArea_body_entered(body, enemy):
	pass

func on_VisionArea_body_exited(body, enemy):
	if body is Character:
		enemy.plants_to_eat = enemy.get_surrounding_plants()
		if enemy.plants_to_eat:
			enemy.current_state = enemy.get_node("States/Eating")
		else:
			enemy.current_state = enemy.get_node("States/Wandering")

