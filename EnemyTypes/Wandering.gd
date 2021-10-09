extends Node


const DIR_CHANGE_TIME = 2.0
var timer = 0

var direction = Vector2.ZERO
var speed = 50

func physics_process(delta, enemy):
	enemy.get_node("Label").set_text("wandering")
	self.timer -= delta
	if self.timer <= 0:
		self.timer = DIR_CHANGE_TIME
		self.direction = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT][randi() % 4]

	enemy.move_and_slide(self.direction * self.speed)

func on_VisionArea_body_entered(body, enemy):
	if body is Character:
		enemy.current_state = enemy.get_node("States/Attacking")
	if body is Plant:
		enemy.plants_to_eat = enemy.get_surrounding_plants()
		enemy.current_state = enemy.get_node("States/Eating")

func on_VisionArea_body_exited(body, enemy):
	pass
