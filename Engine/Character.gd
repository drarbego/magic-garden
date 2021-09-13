extends KinematicBody2D


class_name Character


var speed = 300
var is_walking = false
var has_water = false
var dir = Vector2.ZERO
var do_interaction = FuncRef.new()

var fire_balls = 0

var near_plants = {}


export var world_path: NodePath
onready var world = get_node(world_path)

func _process(delta):
	var anim_name = "walking" if self.is_walking else "idle"
	var anim_dir = "down"
	if self.dir.y < 0:
		anim_dir = "up"
	if self.dir.x != 0:
		anim_dir = "side"

	$Sprite.flip_h = (anim_dir == "side" and self.dir.x > 0)
	$AnimationPlayer.play(anim_name + "_" + anim_dir)
	$Debug.set_text("has water " + str(has_water))

func _unhandled_input(event):
	if event.is_action_released("ui_select"):
		if self.do_interaction.is_valid():
			self.do_interaction.call_func(self)
		elif self.near_plants.empty(): # being lazy
			self.world.spawn_plant(self)

func _physics_process(delta):
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	self.is_walking = x or y
	self.dir = Vector2(x, y).normalized()

	move_and_slide(dir * speed)
