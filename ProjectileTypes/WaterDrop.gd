extends Projectile


class_name WaterDrop


const MAX_DIST_INITAL_POS = 50.0
const MAX_EXTRA_RAND_ROTATION = 15.0
const MAX_EXTRA_RAND_SPEED = 20.0

var player: Object = null
var direction = Vector2.ZERO
var speed = 50.0
var initial_pos := Vector2.ZERO

func _ready():
	randomize()
	var rand_extra_rotation = (randf() * 2 * MAX_EXTRA_RAND_ROTATION) - MAX_EXTRA_RAND_ROTATION
	self.direction = direction.rotated(deg2rad(rand_extra_rotation))
	var rand_extra_speed = self.speed + randf() * MAX_EXTRA_RAND_SPEED
	self.speed = rand_extra_speed
	self.initial_pos = self.global_position

func _physics_process(_delta):
	var dist_to_initial_pos = (self.global_position - self.initial_pos).length()
	if dist_to_initial_pos > MAX_DIST_INITAL_POS and not self.is_queued_for_deletion():
		self.queue_free()

	move_and_slide(self.direction * self.speed)
