extends Projectile


const MAX_DIST_INITAL_POS = 500.0

var direction := Vector2.ZERO
var speed := 450.0
var initial_pos := Vector2.ZERO

func _ready():
	self.initial_pos = self.global_position

func _physics_process(delta):
	var dist_to_initial_pos = (self.global_position - self.initial_pos).length()
	if dist_to_initial_pos > MAX_DIST_INITAL_POS and not self.is_queued_for_deletion():
		self.queue_free()

	move_and_slide(self.direction * self.speed)
