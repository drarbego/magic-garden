extends Action

var WaterDrop = preload("res://ProjectileTypes/WaterDrop.tscn")

var is_shooting = false
const COOLDOWN_TIME := 0.1
var cooldown := COOLDOWN_TIME
var amount: float = 0.0

func get_projectile_pkg_scene_name():
	return str(WaterDrop)

func increase_projectiles_by(_amount):
	self.amount += _amount

func has_enough_projectiles():
	return amount > 0

func decrease_projectiles_by(_amount):
	self.amount -= _amount

func _physics_process(delta):
	self.cooldown -= delta

	if self.is_shooting and self.has_enough_projectiles():
		self.decrease_projectiles_by(delta)

	if self.cooldown <= 0.0:
		self.cooldown = COOLDOWN_TIME
		if self.is_shooting and self.has_enough_projectiles():
			self.spawn_projectile()

func _process(delta):
	$Icon/ContentBar.set_visible(self.is_shooting)
	$Icon/ContentBar.set_value(100 * (self.amount / 5))


func spawn_projectile():
	var water_drop = WaterDrop.instance().init(
		self.player,
		$Icon.global_position,
		(get_global_mouse_position() - self.global_position).normalized()
	)
	self.player.world.add_child(water_drop)

func shoot():
	self.is_shooting = true

func stop_shooting():
	self.is_shooting = false
