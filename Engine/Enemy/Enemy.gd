extends KinematicBody2D


class_name Enemy


const DIR_CHANGE_TIME = 2.0
var timer = 0

var direction = Vector2.ZERO
var speed = 50

func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		timer = DIR_CHANGE_TIME
		self.direction = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT][randi() % 4]

	move_and_slide(self.direction * self.speed)

func _on_HitBox_body_entered(body):
	if body is FireBall:
		self.queue_free()
