extends Action


const FireBall = preload("res://ProjectileTypes/FireBall.tscn")
const item_key = str(FireBall) 
const COOLDOWN_TIME := 0.5
var cooldown := 0.0

func has_enough_projectiles():
	return self.player.get_item_quantity(self.item_key) > 0

func decrease_projectiles():
	self.player.remove_item_from_inventory(self.item_key, 1)

func spawn_projectile():
	var fire_ball = FireBall.instance().init(
		$Icon.global_position,
		(get_global_mouse_position() - self.global_position).normalized()
	)
	self.player.world.add_child(fire_ball)

func shoot():
	if cooldown <= 0 and self.has_enough_projectiles():
		self.decrease_projectiles()
		spawn_projectile()
		self.cooldown = COOLDOWN_TIME

func _physics_process(delta):
	if self.cooldown > 0:
		self.cooldown -= delta
