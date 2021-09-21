extends Node2D

class_name Action

var player: Object = null
var world: Object = null
var distance: float = 0.0
var is_active: bool = false


func init(_player: Object, _world: Object, _distance):
	self.player = _player
	self.world = _world
	self.distance = _distance

	return self

func _process(_delta):
	self.set_visible(self.is_active)
	$Icon.position = (get_global_mouse_position() - self.global_position).normalized() * self.distance

func _unhandled_input(event):
	if not self.is_active:
		return

	if event.is_action_pressed("shoot"):
		self.shoot()
	if event.is_action_released("shoot"):
		self.stop_shooting()

func shoot():
	# NOT IMPLEMENTED
	pass

func stop_shooting():
	# NOT IMPLEMENTED
	pass
