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

func _ready():
	pass
	# for action in $Actions.get_children():
	# 	if action.has_method("get_projectile_pkg_scene_name"):
	# 		self.projectile_to_action[action.get_projectile_pkg_scene_name()] = action

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
		var action = $Actions.get_child(self.action_cursor).get_action().init(self, ACTION_DISTANCE)
		self.set_current_action(action)

func _physics_process(delta):
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	self.is_walking = x or y
	self.dir = Vector2(x, y).normalized()

	move_and_slide(dir * speed)

func increase_action_projectiles(projectile_type, amount):
	if projectile_type.instance().is_in_group("plants"):
		$Actions/PlantingAction.increase_plant_by(projectile_type, amount)
	elif str(projectile_type) in self.projectile_to_action:
		var action = self.projectile_to_action[str(projectile_type)]
		action.increase_projectiles_by(amount)

func set_current_action(action):
	if get_node(self.CURRENT_ACTION_NAME):
		var previous_action = get_node(self.CURRENT_ACTION_NAME)
		previous_action.set_name(self.CURRENT_ACTION_NAME + "_delete")
		previous_action.queue_free()
	
	action.set_name(self.CURRENT_ACTION_NAME)
	add_child(action)
