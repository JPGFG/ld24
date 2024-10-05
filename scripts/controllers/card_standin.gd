extends TextureRect

@export var label_text: String

func _on_area_2d_mouse_entered():
	self.scale.x = 1.2
	self.scale.y = 1.2


func _on_area_2d_mouse_exited():
	self.scale.x = 1
	self.scale.y = 1
