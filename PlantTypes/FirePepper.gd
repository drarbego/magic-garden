extends Plant

var projectile = preload("res://ProjectileTypes/FireBall.tscn")
var projectile_amount: int = 5

func give_product():
	# Se puede parametrizar y mover esta función al padre
	self.player.increase_action_projectiles(self.projectile, 5)
	self.produced = false
	$ProductionTimer.start()

func _process(delta):
	$Menu.set_visible(self.is_character_near)
	$Menu/VBoxContainer/HBoxContainer.set_visible(self.produced)

func _on_GetProduct_pressed():
	self.give_product()
