extends Plant


var is_shooting = false
var health_increase_per_sec = 2.0

func has_enough_energy():
	return self.energy >= 0

func physics_process(delta):
	if self.is_shooting and self.has_enough_energy():
		self.decrease_energy(self.energy_cost * delta)
		self.player.cure(self.health_increase_per_sec * delta)
		self.is_shooting = self.has_enough_energy()

func shoot():
	self.is_shooting = true

func stop_shooting():
	self.is_shooting = false
