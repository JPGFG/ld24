extends Sprite2D

var rotation_mult : float = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation+= rotation_mult * delta
