extends Area2D


const WaterDropItem = preload("res://ItemTypes/WaterDropItem.tscn")

onready var progress_bar = $Display/ProgressBar
onready var player = get_node("../Character")

export var max_water := 20.0
var water:= max_water
export var water_transfer_speed := 1.0
var is_player_near := false

func provide_water():
	if self.water >= 0.0:
		var water_taken = min(self.water, self.player.max_water - self.player.water)

		self.player.replenish_water(water_taken, self.water_transfer_speed)
		$Tween.interpolate_property(self, "water", self.water, self.water-water_taken, self.water_transfer_speed)
		$Tween.start()

func stop_providing():
	self.player.stop_replenishing_water()
	$Tween.remove_all()

func _on_WaterDispenser_body_entered(body):
	if body is Character:
		$Display.set_visible(true)
		self.is_player_near = true

func _on_WaterDispenser_body_exited(body):
	if body is Character:
		$Display.set_visible(false)
		self.is_player_near = false
		$Tween.remove_all()

func _on_ActionButton_button_down():
	self.provide_water()

func _on_ActionButton_button_up():
	self.stop_providing()
	$Tween.remove_all()

func _process(_delta):
	var value = (self.water / self.max_water) * progress_bar.max_value
	self.progress_bar.set_value(value)
