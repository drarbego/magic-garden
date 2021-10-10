extends KinematicBody2D


class_name Character

const CURRENT_ACTION_NAME = "CurrentAction"
const ACTION_DISTANCE = 30

var speed = 300
var is_walking = false
var dir = Vector2.ZERO

var near_plants = {}
var inventory = {}


export var world_path: NodePath
onready var world = get_node(world_path)

var action_cursor = 0

class Item:
	var quantity
	var max_quantity

	func _init(_quantity, _max_quantity):
		self.quantity = _quantity
		self.max_quantity = _max_quantity

func _ready():
	self.set_current_action($Actions.get_child(self.action_cursor))

func _process(delta):
	var anim_name = "walking" if self.is_walking else "idle"
	var anim_dir = "down"
	if self.dir.y < 0:
		anim_dir = "up"
	if self.dir.x != 0:
		anim_dir = "side"

	$Sprite.flip_h = (anim_dir == "side" and self.dir.x > 0)
	$AnimationPlayer.play(anim_name + "_" + anim_dir)

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

func add_item_to_inventory(item_key: String, quantity, max_quantity=null):
	if not item_key in self.inventory:
		self.inventory[item_key] = Item.new(0, max_quantity)

	var item = self.inventory[item_key]
	if item.max_quantity:
		item.quantity = clamp(item.quantity + quantity, 0, item.max_quantity)
	else:
		self.inventory[item_key].quantity += quantity

func set_current_action(action_caller):
	if get_node(self.CURRENT_ACTION_NAME):
		var previous_action = get_node(self.CURRENT_ACTION_NAME)
		previous_action.set_name(self.CURRENT_ACTION_NAME + "_delete")
		previous_action.queue_free()
	var action = action_caller.get_action().init(self, ACTION_DISTANCE)
	action.set_name(self.CURRENT_ACTION_NAME)
	add_child(action)
