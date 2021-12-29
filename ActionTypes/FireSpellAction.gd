extends Action


const FirePepperSeedItem = preload("res://ItemTypes/FirePepperSeedItem.tscn")
const item_key = str(FirePepperSeedItem) 
const COOLDOWN_TIME := 0.5
var cooldown := 0.0

func has_enough_energy():
	print(self.player.energy)
	var plant = self.player.get_current_plant()

	if not plant:
		return false

	return self.player.energy >= plant.get_energy_cost()

func decrease_energy():
	var plant = self.player.get_current_plant()

	if not plant:
		return

	self.player.energy -= plant.get_energy_cost()

func trigger_spell(spell):
	var instance = spell.instance().init(
		$Icon.global_position,
		(get_global_mouse_position() - self.global_position).normalized()
	)
	self.player.world.add_child(instance)

func shoot():
	var spell = self.player.get_plant_spell()

	if not spell:
		return

	if cooldown <= 0 and self.has_enough_energy():
		self.decrease_energy()
		trigger_spell(spell)
		self.cooldown = COOLDOWN_TIME

func _physics_process(delta):
	if self.cooldown > 0:
		self.cooldown -= delta
