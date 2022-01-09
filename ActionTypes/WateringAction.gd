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
	return self.player.get_item_quantity(self.item_key) > 0

func decrease_projectiles_by(quantity):
	self.player.remove_item_from_inventory(self.item_key, quantity)

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

	var item = self.player.get_item(self.item_key)
	if item:
		$Icon/ContentBar.set_value($Icon/ContentBar.max_value * (item.quantity / item.max_quantity))
	else:
		$Icon/ContentBar.set_value(0)

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
