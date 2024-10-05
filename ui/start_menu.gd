class_name StartMenu
extends Control

@export var animation_player: AnimationPlayer
var germ_orbital_array : Array[GermOrbital]
@onready var flu_line : Line2D = $"FluLine"
var flu_endpoint

func _ready():
	for child in get_children():
		if child is GermOrbital:
			germ_orbital_array.push_back(child)
	
	flu_endpoint = flu_line.points[flu_line.points.size() - 1]
	
	for orbital in germ_orbital_array:
		orbital.animation_player.play("orbit")
		await get_tree().create_timer(2).timeout
		

func _physics_process(delta):
	var orbital_pos = germ_orbital_array[0].texture_rect.get_child(0).global_position.x
	if (( orbital_pos > 200 and orbital_pos < 700) and germ_orbital_array[0].texture_rect.z_index > 0):
		flu_line.visible = true
		flu_line.points[flu_line.points.size() - 1] = germ_orbital_array[0].texture_rect.get_child(0).global_position
	else:
		flu_line.visible = false
