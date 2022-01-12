extends Node
var cooldown = 1.0

func physics_process(delta, enemy):
	enemy.get_node("Label").set_text("attacking")
	cooldown -= delta
	if cooldown <= 0:
		var dir = (enemy.character.global_position - enemy.global_position).normalized()
		var projectile = enemy.projectile.instance().init(
			enemy.global_position + 60*dir,
			dir,
			enemy
		)
		enemy.character.world.add_child(projectile)
		cooldown = 1.0

func on_VisionArea_body_entered(body, enemy):
	pass

func on_VisionArea_body_exited(body, enemy):
	if body is Character:
		enemy.character = null
		enemy.plants_to_eat = enemy.get_surrounding_plants()
		if enemy.plants_to_eat:
			enemy.current_state = enemy.get_node("States/Eating")
		else:
			enemy.current_state = enemy.get_node("States/Wandering")

