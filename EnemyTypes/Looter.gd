extends Enemy


func _ready():
	self.current_state = $States/Wandering

func physics_process(delta):
	self.current_state.physics_process(delta, self)

func on_HitBox_body_entered(body):
	# damage -> hurting
	pass

func on_VisionArea_body_entered(body):
	# if player -> attacking
	# if plant -> eating
	pass

func on_VisionArea_body_exited(body):
	# if player -> wandering
	pass
