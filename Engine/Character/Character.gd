extends KinematicBody2D


class_name Character

var speed = 300
var is_walking = false
var dir = Vector2.ZERO

var near_plants = {}


export var world_path: NodePath
onready var world = get_node(world_path)

const WateringAction = preload("res://ActionTypes/WateringAction.tscn")
const FireSpellAction = preload("res://ActionTypes/FireSpellAction.tscn")

var action_cursor = 0
var actions = [WateringAction, FireSpellAction]
var projectile_to_action_index = {
	str(WateringAction.instance().WaterDrop): 0,
	str(FireSpellAction.instance().FireBall): 1
}

func _ready():
	for action_class in self.actions:
		var action = action_class.instance().init(self, self.world, 20.0)
		$Actions.add_child(action)
	$Actions.get_child(self.action_cursor).is_active = true

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
	if event.is_action_released("ui_select"):
		if self.near_plants.empty(): # being lazy
			self.world.spawn_plant(self)
	if event.is_action_pressed("change_action"):
		$Actions.get_child(self.action_cursor).is_active = false
		self.action_cursor = (self.action_cursor + 1) % len(self.actions)
		$Actions.get_child(self.action_cursor).is_active = true

func _physics_process(delta):
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	self.is_walking = x or y
	self.dir = Vector2(x, y).normalized()

	move_and_slide(dir * speed)

func increase_action_projectiles(projectile_type, amount):
	if str(projectile_type) in self.projectile_to_action_index:
		var index = self.projectile_to_action_index[str(projectile_type)]
		$Actions.get_child(index).increase_projectiles_by(amount)
