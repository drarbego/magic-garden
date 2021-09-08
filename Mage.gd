extends KinematicBody2D


var speed = 300
var is_walking = false
var dir = Vector2.ZERO

const FirePepper = preload("res://PlantTypes/FirePepper.tscn")


func _process(delta):
	var anim_name = "walking" if self.is_walking else "idle"
	var anim_dir = "down"
	if self.dir.y < 0:
		anim_dir = "up"
	if self.dir.x != 0:
		anim_dir = "side"

	$Sprite.flip_h = (anim_dir == "side" and self.dir.x > 0)
	$AnimationPlayer.play(anim_name + "_" + anim_dir)
	$Debug.set_text(anim_name + "_" + anim_dir)

func _unhandled_input(event):
	if event.is_action_released("ui_select"):
		self.plant()

func plant():
	var fire_pepper = FirePepper.instance()
	fire_pepper.global_position = self.global_position
	get_parent().add_child(fire_pepper)

func _physics_process(delta):
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	self.is_walking = x or y
	self.dir = Vector2(x, y).normalized()

	move_and_slide(dir * speed)
