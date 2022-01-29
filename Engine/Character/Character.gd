extends KinematicBody2D


class_name Character

const CURRENT_ACTION_NAME = "CurrentAction"
const ACTION_DISTANCE = 30

var speed = 300
var is_walking = false
var dir = Vector2.ZERO
var max_health = 50.0
var health = max_health
var max_water = 10.0

# make it a reference to the plant obj and only
# make it null if is the same instance id
var near_plants = {}
onready var inventory = Inventory.new(self, 10)


export var world_path: NodePath
onready var world = get_node(world_path)

var action_cursor = 0

class Inventory:
	# add concept of weight
	class Item:
		var quantity
		var max_quantity
		var klass

		func _init(_quantity, _max_quantity, _klass):
			self.quantity = _quantity
			self.max_quantity = _max_quantity
			self.klass = _klass


	var items := {}
	var max_capacity: int
	var character

	func _init(_character, _max_capacity: int):
		self.character = _character
		self.max_capacity = _max_capacity

	func add_item(item_class: PackedScene, quantity, max_quantity=null):
		var item_key = str(item_class)
		if not item_key in self.items:
			self.items[item_key] = Item.new(0, max_quantity, item_class)

		var item = self.items[item_key]
		if item.max_quantity:
			item.quantity = clamp(item.quantity + quantity, 0, item.max_quantity)
		else:
			self.items[item_key].quantity += quantity

	func remove_item(item_key: String, quantity):
		if not item_key in self.items:
			return

		var item = self.items[item_key]
		item.quantity -= quantity
		if item.quantity <= 0:
			self.items.erase(item_key)

	func get_item(item_key):
		return items.get(item_key, null)

	func get_ui_elements():
		var results = []

		for item_key in self.items:
			var item = self.items[item_key]
			results.append(item.klass.instance().init(item.quantity))

		return results

# should be used to configure the character after receiving the data from character creation
func init():
	pass

func _ready():
	self.set_current_action($Actions.get_child(self.action_cursor))

func _process(delta):
	var anim_name = "walk" if self.is_walking else "idle"
	var anim_dir = "down"
	if self.dir.y < 0:
		anim_dir = "up"
	if self.dir.x < 0:
		anim_dir = "left"
	if self.dir.x > 0:
		anim_dir = "right"

	$AnimatedSprite.play(anim_name + "_" + anim_dir)

func _unhandled_input(event):
	if event.is_action_pressed("change_action"):
		self.action_cursor = (self.action_cursor + 1) % $Actions.get_child_count()
		self.set_current_action($Actions.get_child(self.action_cursor))

func _physics_process(delta):
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	self.is_walking = x or y
	self.dir = Vector2(x, y).normalized()

	move_and_slide(dir * speed)

#Re pensar esto
func add_item_to_inventory(item_class: PackedScene, quantity, max_quantity=null):
	self.inventory.add_item(item_class, quantity, max_quantity)
	self.world.set_hud_items(self.inventory.get_ui_elements())

func remove_item_from_inventory(item_key: String, quantity):
	self.inventory.remove_item(item_key, quantity)
	self.world.set_hud_items(self.inventory.get_ui_elements())

func get_item(item_key):
	return self.inventory.get_item(item_key)

func get_item_quantity(item_key):
	var item = self.inventory.get_item(item_key)
	return item.quantity if item else 0

func set_current_action(action_caller):
	if get_node(self.CURRENT_ACTION_NAME):
		var previous_action = get_node(self.CURRENT_ACTION_NAME)
		previous_action.set_name(self.CURRENT_ACTION_NAME + "_delete")
		previous_action.queue_free()
	var action = action_caller.get_action().init(self, ACTION_DISTANCE)
	action.set_name(self.CURRENT_ACTION_NAME)
	add_child(action)

func get_current_action():
	return self.get_node(self.CURRENT_ACTION_NAME)

func get_current_plant():
	if self.near_plants.empty():
		return null

	return self.near_plants.get(
		self.near_plants.keys()[0]
	)

func get_plant_spell():
	var plant = self.get_current_plant()

	if not plant:
		return null

	return plant.get_spell()

func _on_HitBox_body_entered(body):
	if not body is Projectile:
		return

	if body.instancer == self:
		return

	var received_damage = body.damage
	self.receive_damage(received_damage)

func receive_damage(damage):
	self.health -= damage
	$HealthBar.value = (self.health / self.max_health) * $HealthBar.max_value

func cure(health_increase):
	self.health = clamp(health + health_increase, 0, self.max_health)
	$HealthBar.value = (self.health / self.max_health) * $HealthBar.max_value
