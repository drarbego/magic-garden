extends Plant

var projectile = preload("res://ProjectileTypes/FireBall.tscn")
var projectile_amount: int = 5

func _process(delta):
	$Menu.set_visible(self.is_character_near)
	$Menu/VBoxContainer/HBoxContainer.set_visible(self.produced)
