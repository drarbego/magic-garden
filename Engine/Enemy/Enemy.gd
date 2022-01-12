extends KinematicBody2D


class_name Enemy

var current_state: Object = null
var character: Object = null
export var projectile: PackedScene = null
export var damage := 0.0
export var max_health := 20.0
var health := self.max_health


func _physics_process(delta):
	self.physics_process(delta)

func physics_process(delta):
	# NOT IMPLEMENTED
	pass

func _on_HitBox_body_entered(body):
	if not body is Projectile:
		return

	if body.instancer == self:
		return

	var received_damage = body.damage
	self.receive_damage(received_damage)

func receive_damage(received_damage):
	self.health -= received_damage
	$HealthBar.value = (self.health / self.max_health) * $HealthBar.max_value

func on_HitBox_body_entered(body):
	# NOT IMPLEMENTED
	pass

func _on_VisionArea_body_entered(body):
	self.on_VisionArea_body_entered(body)

func on_VisionArea_body_entered(body):
	# NOT IMPLEMENTED
	pass

func _on_VisionArea_body_exited(body):
	self.on_VisionArea_body_exited(body)

func on_VisionArea_body_exited(body):
	# NOT IMPLEMENTED
	pass
