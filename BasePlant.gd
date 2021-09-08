extends Node2D


export var sprite_row = 0 # row index for flowers.png
export var production_wait_time = 5.0
export var growth_wait_scalar = 1.0 # at each stage, growth wait time will increase by growth_wait_scalar
export var growth_wait_time = 5.0
const GROWTH_STAGES_COUNT = 3
var stage = 0 # column index for flowers.png

var produced = false


func _ready():
	$ProductionTimer.set_wait_time(self.production_wait_time)
	$GrowthTimer.set_wait_time(self.growth_wait_time)
	$GrowthTimer.start()
	self.update_graphics()

func _on_GrowthTimer_timeout():
	self.growth_wait_time *= self.growth_wait_scalar
	self.stage += 1
	self.update_graphics()
	$PopEffect.play()
	$PopParticles.set_emitting(true)

	if self.stage < GROWTH_STAGES_COUNT - 1:
		$GrowthTimer.set_wait_time(self.growth_wait_time)
		$GrowthTimer.start()

	else:
		print("production timer started")
		$ProductionTimer.start()

func update_graphics():
	$Sprite.set_frame_coords(Vector2(self.stage, self.sprite_row))

func _on_ProductionTimer_timeout():
	print("producing!")
	self.produce()

func _process(delta):
	update()

func _draw():
	if self.produced:
		draw_circle(Vector2.ZERO, 24, Color(1, 0, 1, 0.5))

func produce():
	self.produced = true
