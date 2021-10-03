extends KinematicBody2D


class_name Enemy

var current_state: Object = null


func _physics_process(delta):
	self.physics_process(delta)

func physics_process(delta):
	# NOT IMPLEMENTED
	pass

func _on_HitBox_body_entered(body):
	self.on_HitBox_body_entered(body)

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
