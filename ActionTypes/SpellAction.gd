extends Action


const COOLDOWN_TIME := 0.5
var cooldown := 0.0

func has_enough_energy():
	var plant = self.player.get_current_plant()

	if not plant:
		return false

	return plant.has_enough_energy()

func decrease_energy():
	var plant = self.player.get_current_plant()

	if not plant:
		return

	plant.decrease_energy()

func shoot():
	var plant = self.player.get_current_plant()

	if not plant:
		return

	plant.shoot()

func stop_shooting():
	var plant = self.player.get_current_plant()

	if not plant:
		return

	plant.stop_shooting()
