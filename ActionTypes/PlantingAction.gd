extends Action


const FirePepper = preload("res://PlantTypes/FirePepper.tscn")
const HealingMint = preload("res://PlantTypes/HealingMint.tscn")

const FirePepperSeedItem = preload("res://ItemTypes/FirePepperSeedItem.tscn")
const HealingMintSeedItem = preload("res://ItemTypes/HealingMintSeedItem.tscn")

var available_plants = [
	FirePepper,
	HealingMint
]
var available_seeds = [
	FirePepperSeedItem,
	HealingMintSeedItem
]
var current_plant: int = 0

func _ready():
	self.update_current_plant_texture()

func update_current_plant_texture():
	var plant = self.available_plants[self.current_plant].instance()
	var plant_sprite = plant.get_node("Sprite")
	$Icon.set_texture(plant_sprite.get_texture())
	$Icon.vframes = plant_sprite.vframes
	$Icon.hframes = plant_sprite.hframes
	$Icon.set_frame_coords(Vector2(0, plant.sprite_row))

func has_enough_plants():
	var item_key = str(self.available_seeds[self.current_plant])
	return self.player.get_item_quantity(item_key) > 0

func decrease_current_plant_by(quantity):
	var item_key = str(self.available_seeds[self.current_plant])
	self.player.remove_item_from_inventory(item_key, quantity)

func _unhandled_input(event):
	if event.is_action_released("ui_select") and self.available_plants:
		self.current_plant = (self.current_plant + 1) % len(self.available_plants)
		self.update_current_plant_texture()

func shoot():
	if self.player.near_plants.empty() and self.has_enough_plants():
		var plant = self.available_plants[self.current_plant].instance().init(self.player)
		plant.global_position = self.player.global_position
		self.player.world.spawn_plant(plant)
		self.decrease_current_plant_by(1)

func _process(delta):
	if not self.has_enough_plants() or not self.player.near_plants.empty():
		$Icon.modulate.a = 0.35
	else:
		$Icon.modulate.a = 1.0
