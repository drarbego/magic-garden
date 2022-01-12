extends Enemy

var plants_to_eat = []

func _ready():
	self.current_state = $States/Wandering

func physics_process(delta):
	self.current_state.physics_process(delta, self)

func on_VisionArea_body_entered(body):
	self.current_state.on_VisionArea_body_entered(body, self)

func on_VisionArea_body_exited(body):
	self.current_state.on_VisionArea_body_exited(body, self)

func get_surrounding_plants():
	var bodies = []
	for body in $VisionArea.get_overlapping_bodies():
		if body is Plant:
			bodies.append(body)

	return bodies
