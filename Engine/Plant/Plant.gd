extends Node2D


class_name Plant


export var sprite_row := 0 # row index for flowers.png
export var production_wait_time := 5.0
export var growth_wait_time := 5.0
export var growth_wait_scalar := 1.0 # at each stage, growth wait time will increase by water_wait_scalar
export var max_water_content := 10.0
onready var water_content = max_water_content
export var water_loss_per_sec = 1.0
const GROWTH_STAGES_COUNT = 3

# STATE
var stage = 0 # column index for flowers.png
var needs_water = false
var produced = false
var is_character_near = false
onready var current_state = $States/Growing
var world: Object = null

func change_state(new_state):
	self.current_state = new_state
	if self.current_state.has_method("ready"):
		self.current_state.ready(self)

func init(_world: Object):
	self.world = _world

	return self

func _ready():
	self.update_graphics()
	self.change_state($States/Growing)

func _on_HitBox_body_entered(body):
	if self.current_state.has_method("on_HitBox_body_entered"):
		self.current_state.on_HitBox_body_entered(body, self)

func _on_HitBox_body_exited(body):
	if self.current_state.has_method("on_HitBox_body_exited"):
		self.current_state.on_HitBox_body_exited(body, self)

func _on_CharacterDetector_body_entered(body):
	if self.current_state.has_method("on_CharacterDetector_body_entered"):
		self.current_state.on_CharacterDetector_body_entered(body, self)
		self.is_character_near = true

func _on_CharacterDetector_body_exited(body):
	if self.current_state.has_method("on_CharacterDetector_body_exited"):
		self.current_state.on_CharacterDetector_body_exited(body, self)
		self.is_character_near = false

func _on_GrowthTimer_timeout():
	if self.current_state.has_method("on_GrowthTimer_timeout"):
		self.current_state.on_GrowthTimer_timeout(self)

func _on_ProductionTimer_timeout():
	if self.current_state.has_method("on_ProductionTimer_timeout"):
		self.current_state.on_ProductionTimer_timeout(self)

func receive_water():
	self.water_content = self.max_water_content

func update_graphics():
	$Sprite.set_frame_coords(Vector2(self.stage, self.sprite_row))

func _process(delta):
	self.water_content = clamp(
		self.water_content - self.water_loss_per_sec * delta,
		0,
		self.max_water_content
	)
	self.needs_water = (self.water_content / self.max_water_content) < 0.5

	if self.current_state.has_method("process"):
		self.current_state.process(delta, self)
