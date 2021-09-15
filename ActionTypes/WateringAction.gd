extends Action

var WaterDrop = preload("res://ProjectileTypes/WaterDrop.tscn")

var is_shooting = false
const COOLDOWN_TIME = 0.1
var cooldown = COOLDOWN_TIME

func _physics_process(delta):
	self.cooldown -= delta

	if self.is_shooting and self.player.water_content > 0.0:
		self.player.water_content -= delta

	if self.cooldown <= 0.0:
		self.cooldown = COOLDOWN_TIME
		if self.is_shooting and self.player.water_content > 0.0:
			self.spawn_projectile()

func spawn_projectile():
	var water_drop = WaterDrop.instance().init(
		self.player,
		$Icon.global_position,
		(get_global_mouse_position() - self.global_position).normalized()
	)
	self.world.add_child(water_drop)

func shoot():
	self.is_shooting = true

func stop_shooting():
	self.is_shooting = false
