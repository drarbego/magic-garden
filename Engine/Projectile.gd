extends KinematicBody2D


class_name Projectile

var instancer: Object = null
export var damage := 0.0

func init(pos: Vector2, dir: Vector2, _instancer: Object):
	self.direction = dir
	self.global_position = pos
	self.instancer = _instancer

	return self
