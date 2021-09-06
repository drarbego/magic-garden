extends Node2D


export var production_wait_time = 5.0

func _ready():
	$ProductionTimer.set_wait_time(self.production_wait_time)

func _on_ProductionTimer_timeout():
	self.produce()

func produce():
	pass
