extends Node2D


class_name Plant


export var sprite_row = 0 # row index for flowers.png
export var production_wait_time = 5.0
export var water_wait_scalar = 1.0 # at each stage, growth wait time will increase by water_wait_scalar
export var water_wait_time = 5.0
const GROWTH_STAGES_COUNT = 3

# STATE
var stage = 0 # column index for flowers.png
var needs_water = true

var produced = false


func _ready():
	$ProductionTimer.set_wait_time(self.production_wait_time)
	$WaterTimer.set_wait_time(self.water_wait_time)
	$WaterTimer.start()
	self.update_graphics()

func _on_InteractionDetector_body_entered(body):
	if body is Character:
		body.do_interaction = funcref(self, "receive_water")

func _on_InteractionDetector_body_exited(body):
	if body is Character:
		body.do_interaction = FuncRef.new()

func _on_CharacterDetector_body_entered(body):
	if body is Character:
		body.near_plants[self.get_instance_id()] = self

func _on_CharacterDetector_body_exited(body):
	if body is Character:
		body.near_plants.erase(self.get_instance_id())

func _on_WaterTimer_timeout():
	self.needs_water = true

func receive_water(player):
	if self.stage == GROWTH_STAGES_COUNT - 1 or not self.needs_water:
		return

	# todo check player has water

	self.water_wait_time *= self.water_wait_scalar
	self.stage += 1
	self.needs_water = false
	$PopEffect.play()
	$PopParticles.set_emitting(true)
	self.update_graphics()

	if self.stage == GROWTH_STAGES_COUNT - 1:
		self.produce()
	else:
		$WaterTimer.set_wait_time(self.water_wait_time)
		$WaterTimer.start()

func update_graphics():
	$Sprite.set_frame_coords(Vector2(self.stage, self.sprite_row))

func _on_ProductionTimer_timeout():
	print("producing!")

func _process(delta):
	update()
	if self.needs_water:
		$AnimationPlayer.play("water")
	else:
		$AnimationPlayer.stop()
		$WaterDrop.visible = false

func _draw():
	if self.produced:
		draw_circle(Vector2.ZERO, 24, Color(1, 0, 1, 0.5))

func produce():
	self.produced = true
