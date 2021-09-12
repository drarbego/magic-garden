extends Node2D


const FirePepper = preload("res://PlantTypes/FirePepper.tscn")

func spawn_plant(player):
	var fire_pepper = FirePepper.instance()
	fire_pepper.global_position = player.global_position
	player.near_plants[fire_pepper.get_instance_id()] = fire_pepper
	$Plants.add_child(fire_pepper)
