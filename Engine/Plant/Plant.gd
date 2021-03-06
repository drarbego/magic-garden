extends Node2D


class_name Plant
# Change to area
# when player is close, increase magic kind


export var production_wait_time := 5.0
export var growth_wait_time := 5.0
export var growth_wait_scalar := 1.0 # at each stage, growth wait time will increase by water_wait_scalar
export var max_water_content := 10.0
onready var water_content = max_water_content
export var water_loss_per_sec := 1.0
export var produced_item: PackedScene
export var spell: PackedScene = null
export var produced_item_quantity := 1
export var texture_stage_0 : Texture = null
export var texture_stage_1 : Texture = null
export var texture_stage_2 : Texture = null
export var COOLDOWN_TIME := 0.5
const MAX_ENERGY = 10.0
export var energy_increase_per_sec := 0.0
export var energy_cost := 0.0
onready var produced_item_key = str(self.produced_item)
const GROWTH_STAGES_COUNT = 3
var magic_type = null
var cooldown := 0.0

# STATE
var stage = 0 # column index for flowers.png
var needs_water = false
var produced = false
var is_character_near = false
onready var current_state = $States/Growing
var player: Object = null

var is_increasing_energy = false
var energy = 0.0

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

# TODO rethink this mechanism
func give_product():
	self.player.add_item_to_inventory(self.produced_item, self.produced_item_quantity)
	self.produced = false
	$ProductionTimer.start()

func receive_water():
	self.water_content = self.max_water_content

func update_graphics():
	if self.stage == 0:
		$Sprite.set_texture(self.texture_stage_0)
		$AnimationPlayer.play("sprout")
	if self.stage == 1:
		$Sprite.set_texture(self.texture_stage_1)
	if self.stage == 2:
		$Sprite.set_texture(self.texture_stage_2)

func get_spell():
	return self.spell

func get_energy_cost():
	return self.energy_cost

func _process(delta):
	$Display.set_visible(self.is_character_near)
	self.water_content = clamp(
		self.water_content - self.water_loss_per_sec * delta,
		0,
		self.max_water_content
	)
	self.needs_water = (self.water_content / self.max_water_content) < 0.5
	if self.water_content <= 0:
		self.queue_free()
	self.update_water_animation()
	$Display/EnergyBar.value = (self.energy / self.MAX_ENERGY) * $Display/EnergyBar.max_value

	if self.current_state.has_method("process"):
		self.current_state.process(delta, self)

func _physics_process(delta):
	if self.cooldown > 0:
		self.cooldown -= delta
	self.physics_process(delta)

func physics_process(delta):
	pass

func update_water_animation():
	if self.needs_water:
		var anim_speed =  0.5 / max(0.1, self.water_content / self.max_water_content)
		$AnimationPlayer.play("water", -1, anim_speed)
	else:
		$WaterDrop.visible = false

func handle_impact(projectile):
	if projectile is WaterDrop:
		self.receive_water()

func has_enough_energy():
	return self.energy >= self.energy_cost

func is_cooled_down():
	return self.cooldown <= 0

func decrease_energy(custom_decrease=null):
	if custom_decrease:
		self.energy -= custom_decrease
	else:
		self.energy -= self.energy_cost

func shoot():
	pass

func stop_shooting():
	pass
