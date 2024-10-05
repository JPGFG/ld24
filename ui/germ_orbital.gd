class_name GermOrbital
extends Marker2D


@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var texture_rect: TextureRect = $"OrbitalGerm"
@onready var label: Label = $"OrbitalGerm/Label"
@export var labelText: String
@export var texture: Texture
@export var rotate_speed : int = 5

func _ready():
	label.text = labelText
	texture_rect.texture = texture

func orbital_start():
	animation_player.play("orbit")

func _physics_process(delta):
	#texture_rect.rotation += rotate_speed * delta
	pass
