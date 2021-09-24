extends Action


# figure out a way to make it work for multiple plant types
const FirePepper = preload("res://PlantTypes/FirePepper.tscn")

var amount = 10

func get_projectile_pkg_scene_name():
	return str(FirePepper)

func increase_projectiles_by(_amount):
	self.amount += _amount

func has_enough_projectiles():
	return amount > 0

func decrease_projectiles_by(_amount):
	self.amount -= _amount


func shoot():
	if self.player.near_plants.empty() and self.has_enough_projectiles():
		var fire_pepper = FirePepper.instance().init(self.player)
		fire_pepper.global_position = self.player.global_position
		self.player.world.spawn_plant(fire_pepper)
		self.decrease_projectiles_by(1)

func _process(delta):
	if not self.player.near_plants.empty():
		$Icon.modulate.a = 0.35
	else:
		$Icon.modulate.a = 1.0
