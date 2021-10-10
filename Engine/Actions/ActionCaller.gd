extends Node

export var action_scene: PackedScene


func get_action():
	return action_scene.instance()

func _get_configuration_warning():
	if not self.action_scene:
		return "No action_path configured"

	return ""
