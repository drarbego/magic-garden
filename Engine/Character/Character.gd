extends KinematicBody2D


class_name Character

var speed = 300
var is_walking = false
var dir = Vector2.ZERO
var do_interaction = FuncRef.new()

# replace with water amount
var water_content:float = 0.0

var fire_balls = 0

var near_plants = {}


export var world_path: NodePath
onready var world = get_node(world_path)

const WateringAction = preload("res://ActionTypes/WateringAction.tscn")
const FireSpellAction = preload("res://ActionTypes/FireSpellAction.tscn")

var action_cursor = 0
var actions = [WateringAction, FireSpellAction]
var actions_state = {
	str(WateringAction): {
		"amount": 0
	},
	str(FireSpellAction): {
		"amount": 5
	}
}

func _ready():
	var action = WateringAction.instance().init(self, self.world, 20.0)
	$Action.add_child(action)

func _process(delta):
	var anim_name = "walking" if self.is_walking else "idle"
	var anim_dir = "down"
	if self.dir.y < 0:
		anim_dir = "up"
	if self.dir.x != 0:
		anim_dir = "side"

	$Sprite.flip_h = (anim_dir == "side" and self.dir.x > 0)
	$AnimationPlayer.play(anim_name + "_" + anim_dir)
	$Debug.set_text("water content " + str(water_content))

func _unhandled_input(event):
	if event.is_action_released("ui_select"):
		if self.do_interaction.is_valid():
			self.do_interaction.call_func(self)
		elif self.near_plants.empty(): # being lazy
			self.world.spawn_plant(self)
	if event.is_action_pressed("change_action"):
		self.action_cursor = (self.action_cursor + 1) % len(self.actions)
		var action = self.actions[self.action_cursor].instance().init(self, self.world, 20.0)
		for child in $Action.get_children():
			child.queue_free()
		$Action.add_child(action)

func _physics_process(delta):
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	self.is_walking = x or y
	self.dir = Vector2(x, y).normalized()

	move_and_slide(dir * speed)

func increase_action_projectiles(projectile_type, amount):
	if str(projectile_type) == str(self.FireSpellAction.instance().FireBall):
		self.actions_state[str(self.FireSpellAction)]["amount"] += amount
	print(self.actions_state)

func get_current_action_state():
	return self.actions_state[str(self.actions[self.action_cursor])]

func has_enough_projectiles() -> bool:
	return self.get_current_action_state()["amount"] > 0

func decrease_projectiles(amount) -> void:
	self.get_current_action_state()["amount"] -= amount
