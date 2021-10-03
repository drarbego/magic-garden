extends Node


const DIR_CHANGE_TIME = 2.0
var timer = 0

var direction = Vector2.ZERO
var speed = 50

func physics_process(delta, enemy):
	self.timer -= delta
	if self.timer <= 0:
		self.timer = DIR_CHANGE_TIME
		self.direction = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT][randi() % 4]

	enemy.move_and_slide(self.direction * self.speed)