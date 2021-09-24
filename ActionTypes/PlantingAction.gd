extends Action

var seeds = 10

func shoot():
	if self.player.near_plants.empty() and self.seeds > 0:
		self.player.world.spawn_plant(self.player)
		self.seeds -= 1

func _process(delta):
	if not self.player.near_plants.empty():
		$Icon.modulate.a = 0.35
	else:
		$Icon.modulate.a = 1.0
