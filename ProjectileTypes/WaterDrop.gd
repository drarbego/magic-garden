extends KinematicBody2D


class_name WaterDrop


var direction = Vector2.ZERO
var speed = 100.0

func init(pos: Vector2, dir: Vector2):
	self.direction = dir
	self.global_position = pos

	return self

func _ready():
	randomize()
	var rand_extra_rotation = (randf() * 40) - 20
	self.direction = direction.rotated(deg2rad(rand_extra_rotation))
	var rand_extra_speed = self.speed + randf() * 100.0
	self.speed = rand_extra_speed

func _process(_delta):
	move_and_slide(self.direction * self.speed)

func _on_LifeTimer_timeout():
	self.queue_free()
