extends Plant

func _process(delta):
	$Menu.set_visible(self.is_character_near)
	$Menu/VBoxContainer/HBoxContainer.set_visible(self.produced)
