extends Area2D


const WaterDropItem = preload("res://ItemTypes/WaterDropItem.tscn")
const MAX_AMOUNT = 5

export var water_content :=	20.0
var is_player_near := false

onready var player = get_node("../Character")

func provide_water(player):
	if self.water_content >= 0.0:
		self.player.add_item_to_inventory(WaterDropItem, min(self.water_content, MAX_AMOUNT), MAX_AMOUNT)
		self.water_content -= MAX_AMOUNT
		$Control/ProgressBar.value =  (self.water_content / 20.0) * $Control/ProgressBar.max_value
		$Tween.interpolate_callback(self, 1.0, "provide_water")

func _on_WaterDispenser_body_entered(body):
	if body is Character:
		$Display.set_visible(true)
		self.is_player_near = true

func _on_WaterDispenser_body_exited(body):
	if body is Character:
		$Display.set_visible(false)
		self.is_player_near = false
		$Tween.remove_all()

func _on_ActionButton_toggled(button_pressed:bool):
	if button_pressed: 
		$Tween.interpolate_callback(self, 1.0, "provide_water")
	else:
		$Tween.remove_all()
