extends Projectile


class_name FireBall


const MAX_DIST_INITAL_POS = 1000.0

var direction := Vector2.ZERO
var speed := 450.0
var initial_pos := Vector2.ZERO

func _ready():
	self.initial_pos = self.global_position

func init(pos: Vector2, dir: Vector2):
	self.direction = dir
	self.global_position = pos

	return self

func _physics_process(delta):
	var dist_to_initial_pos = (self.global_position - self.initial_pos).length()
	if dist_to_initial_pos > MAX_DIST_INITAL_POS and not self.is_queued_for_deletion():
		self.queue_free()

	move_and_slide(self.direction * self.speed)
