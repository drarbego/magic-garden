extends Node2D

class_name Action

export var player_path: NodePath
onready var player: Object = get_node(player_path)
export var distance: float = 0.0
export var is_active: bool = false


func init(_player: Object, _world: Object, _distance):
	self.player = _player
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

func get_projectile_pkg_scene_name():
	# NOT IMPLEMENTED
	pass
