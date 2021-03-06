extends Action

const WaterDrop = preload("res://ProjectileTypes/WaterDrop.tscn")
const WaterDropItem = preload("res://ItemTypes/WaterDropItem.tscn")
const item_key = str(WaterDropItem)


# move is_shooting logic to base action (is_triggered)
# change concept of shooting to triggerig

var is_shooting = false
const COOLDOWN_TIME := 0.1
var cooldown := COOLDOWN_TIME

func has_enough_projectiles():
	return self.player.water > 0

func decrease_projectiles_by(quantity):
	self.player.water -= quantity

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
	if not $Icon/ContentBar.visible:
		return

	$Icon/ContentBar.set_value($Icon/ContentBar.max_value * (self.player.water / self.player.max_water))

func spawn_projectile():
	var water_drop = WaterDrop.instance().init(
		$Icon.global_position,
		(get_global_mouse_position() - self.global_position).normalized(),
		self.player
	)
	self.player.world.add_child(water_drop)

func shoot():
	self.is_shooting = true

func stop_shooting():
	self.is_shooting = false
