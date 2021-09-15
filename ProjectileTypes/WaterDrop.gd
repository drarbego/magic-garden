extends KinematicBody2D


class_name WaterDrop


var player: Object = null
var direction = Vector2.ZERO
var speed = 150.0
const MAX_DIST_FROM_PLAYER = 80.0

func init(_player: Object, pos: Vector2, dir: Vector2):
	self.player = _player
	self.direction = dir
	self.global_position = pos

	return self

func _ready():
	randomize()
	var rand_extra_rotation = (randf() * 40) - 20
	self.direction = direction.rotated(deg2rad(rand_extra_rotation))
	var rand_extra_speed = self.speed + randf() * 100.0
	self.speed = rand_extra_speed

func _physics_process(_delta):
	var dist_to_player = (self.global_position - self.player.global_position).length()
	if dist_to_player > MAX_DIST_FROM_PLAYER and not self.is_queued_for_deletion():
		self.queue_free()

	move_and_slide(self.direction * self.speed)
