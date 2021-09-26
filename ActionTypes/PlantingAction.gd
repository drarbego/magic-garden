extends Action


var plant_amount = {}
var available_plants = []
var current_plant: int = 0

func register_plant(plant_type):
	self.plant_amount[str(plant_type)] = 0
	self.available_plants.append(plant_type)

func increase_plant_by(plant_type, _amount):
	if not str(plant_type) in self.plant_amount:
		register_plant(plant_type)

	self.plant_amount[str(plant_type)] += _amount

func has_enough_plants():
	if not self.available_plants or not str(self.available_plants[self.current_plant]) in self.plant_amount:
		return false

	return self.plant_amount[str(self.available_plants[self.current_plant])] > 0

func decrease_plant_by(plant_type, amount):
	if not str(plant_type) in self.plant_amount:
		register_plant(plant_type)

	self.plant_amount[str(plant_type)] = max(
		self.plant_amount[str(plant_type)] - amount,
		0
	)

func _unhandled_input(event):
	if event.is_action_released("ui_left"):
		self.current_plant = clamp(self.current_plant - 1, 0, len(self.plant_amount) - 1)

	if event.is_action_released("ui_right"):
		self.current_plant = clamp(self.current_plant + 1, 0, len(self.plant_amount) - 1)

func shoot():
	if self.player.near_plants.empty() and self.has_enough_plants():
		var plant = self.available_plants[self.current_plant].instance().init(self.player)
		plant.global_position = self.player.global_position
		self.player.world.spawn_plant(plant)
		self.decrease_plant_by(self.available_plants[self.current_plant], 1)

func _process(delta):
	if not self.has_enough_plants() or not self.player.near_plants.empty():
		$Icon.modulate.a = 0.35
	else:
		$Icon.modulate.a = 1.0
