extends Node2D


class_name Plant
# Change to area
# when player is close, increase magic kind


export var sprite_row := 0 # row index for flowers.png
export var production_wait_time := 5.0
export var growth_wait_time := 5.0
export var growth_wait_scalar := 1.0 # at each stage, growth wait time will increase by water_wait_scalar
export var max_water_content := 10.0
onready var water_content = max_water_content
export var water_loss_per_sec := 1.0
export var produced_item: PackedScene
export var spell: PackedScene = null
export var produced_item_quantity := 1
export var energy_increase_per_sec := 0.0
export var energy_cost := 0.0
onready var produced_item_key = str(self.produced_item)
const GROWTH_STAGES_COUNT = 3
var magic_type = null

# STATE
var stage = 0 # column index for flowers.png
var needs_water = false
var produced = false
var is_character_near = false
onready var current_state = $States/Growing
var player: Object = null

func change_state(new_state):
	self.current_state = new_state
	if self.current_state.has_method("ready"):
		self.current_state.ready(self)

func init(_player: Object):
	self.player = _player

	return self

func _ready():
	self.update_graphics()
	self.change_state($States/Growing)
	self.player.near_plants[self.get_instance_id()] = self

func _on_HitBox_body_entered(body):
	if self.current_state.has_method("on_HitBox_body_entered"):
		self.current_state.on_HitBox_body_entered(body, self)

func _on_HitBox_body_exited(body):
	if self.current_state.has_method("on_HitBox_body_exited"):
		self.current_state.on_HitBox_body_exited(body, self)

func _on_CharacterDetector_body_entered(body):
	if body is Character and self.current_state.has_method("on_CharacterDetector_body_entered"):
		self.current_state.on_CharacterDetector_body_entered(body, self)
		self.is_character_near = true

func _on_CharacterDetector_body_exited(body):
	if body is Character and self.current_state.has_method("on_CharacterDetector_body_exited"):
		self.current_state.on_CharacterDetector_body_exited(body, self)
		self.is_character_near = false

func _on_GrowthTimer_timeout():
	if self.current_state.has_method("on_GrowthTimer_timeout"):
		self.current_state.on_GrowthTimer_timeout(self)

func _on_ProductionTimer_timeout():
	if self.current_state.has_method("on_ProductionTimer_timeout"):
		self.current_state.on_ProductionTimer_timeout(self)

func _on_GetProduct_pressed():
	self.give_product()

func give_product():
	self.player.add_item_to_inventory(self.produced_item, self.produced_item_quantity)
	self.produced = false
	$ProductionTimer.start()

func receive_water():
	self.water_content = self.max_water_content

func update_graphics():
	$Sprite.set_frame_coords(Vector2(self.stage, self.sprite_row))

func get_spell():
	return self.spell

func get_energy_cost():
	return self.energy_cost

func _process(delta):
	self.water_content = clamp(
		self.water_content - self.water_loss_per_sec * delta,
		0,
		self.max_water_content
	)
	self.needs_water = (self.water_content / self.max_water_content) < 0.5
	if self.water_content <= 0:
		self.queue_free()
	self.update_water_animation()

	if self.current_state.has_method("process"):
		self.current_state.process(delta, self)

func update_water_animation():
	if self.needs_water:
		var anim_speed =  0.5 / max(0.1, self.water_content / self.max_water_content)
		$AnimationPlayer.play("water", -1, anim_speed)
	else:
		$AnimationPlayer.stop()
		$WaterDrop.visible = false

func handle_impact(projectile):
	if projectile is WaterDrop:
		self.receive_water()
