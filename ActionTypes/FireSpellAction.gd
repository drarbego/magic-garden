extends Action


const FireBall = preload("res://ProjectileTypes/FireBall.tscn")
const COOLDOWN_TIME := 0.5
var cooldown := 0.0

func spawn_projectile():
	var fire_ball = FireBall.instance().init(
		$Icon.global_position,
		(get_global_mouse_position() - self.global_position).normalized()
	)
	self.world.add_child(fire_ball)

func shoot():
	if cooldown <= 0:
		spawn_projectile()
		self.cooldown = COOLDOWN_TIME

func _physics_process(delta):
	if self.cooldown > 0:
		self.cooldown -= delta
