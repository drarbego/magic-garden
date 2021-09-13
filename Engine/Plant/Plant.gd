extends Node2D


class_name Plant


export var sprite_row := 0 # row index for flowers.png
export var production_wait_time := 5.0
export var growth_wait_time := 5.0
export var growth_wait_scalar := 1.0 # at each stage, growth wait time will increase by water_wait_scalar
export var max_water_content := 10.0
var water_content = max_water_content
export var water_loss_per_sec = 1.0
const GROWTH_STAGES_COUNT = 3

# STATE
var stage = 0 # column index for flowers.png
var needs_water = false
var produced = false
onready var current_state = $States/Growing

func change_state(new_state):
	self.current_state = new_state
	if self.current_state.has_method("ready"):
		self.current_state.ready(self)

func _ready():
	self.update_graphics()
	self.change_state($States/Growing)

func _on_InteractionDetector_body_entered(body):
	if self.current_state.has_method("on_InteractionDetector_body_entered"):
		self.current_state.on_InteractionDetector_body_entered(body, self)

func _on_InteractionDetector_body_exited(body):
	if self.current_state.has_method("on_InteractionDetector_body_exited"):
		self.current_state.on_InteractionDetector_body_exited(body, self)

func _on_CharacterDetector_body_entered(body):
	if self.current_state.has_method("on_CharacterDetector_body_entered"):
		self.current_state.on_CharacterDetector_body_entered(body, self)

func _on_CharacterDetector_body_exited(body):
	if self.current_state.has_method("on_CharacterDetector_body_exited"):
		self.current_state.on_CharacterDetector_body_exited(body, self)

func _on_GrowthTimer_timeout():
	if self.current_state.has_method("on_GrowthTimer_timeout"):
		self.current_state.on_GrowthTimer_timeout(self)

func _on_ProductionTimer_timeout():
	if self.current_state.has_method("on_ProductionTimer_timeout"):
		self.current_state.on_ProductionTimer_timeout(self)

func receive_water(player):
	# todo check player has water

	self.water_content = self.max_water_content
	player.has_water = false

func give_product(player):
	self.produced = false
	player.fire_balls = 10
	$ProductionTimer.start()

func update_graphics():
	$Sprite.set_frame_coords(Vector2(self.stage, self.sprite_row))

func _process(delta):
	self.water_content = clamp(
		self.water_content - self.water_loss_per_sec * delta,
		0,
		self.max_water_content
	)
	self.needs_water = (self.water_content / self.max_water_content) < 0.5
	$Debug.set_text(str(self.needs_water))

	if self.current_state.has_method("process"):
		self.current_state.process(delta, self)
