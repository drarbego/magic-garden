extends TextureRect

var quantity := 0

func init(_quantity):
	self.quantity = _quantity

	return self

func _ready():
	$PanelContainer/Quantity.set_text(str(self.quantity))
