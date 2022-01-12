extends Plant


func shoot():
	if self.cooldown <= 0 and self.has_enough_energy():
		self.decrease_energy()
		var instance = self.spell.instance().init(
			self.player.get_current_action().get_node("Icon").global_position,
			(get_global_mouse_position() - self.global_position).normalized(),
			self.player
		)
		self.player.world.add_child(instance)
		self.cooldown = self.COOLDOWN_TIME

func stop_shooting():
	pass
