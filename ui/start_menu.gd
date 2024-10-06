class_name StartMenu
extends Control

@export var animation_player: AnimationPlayer

var main_scene = "res://scenes/game-board/LocationPicker.tscn"

var germ_orbital_array : Array[GermOrbital]
@onready var flu_line : Line2D = $"FluLine"
@onready var flu_card : PanelContainer = $"InfluenzaBox"
var flu_endpoint

@export var main_menu_items: Array[Button]
@export var sub_menu_items: Array[Button]
@export var sub_menu_panels: Array[MarginContainer]

@onready var sfx_player: AudioStreamPlayer2D = $"SFXPlayer"
@onready var ui_accept_sound: AudioStreamMP3 = preload("res://assets/sounds/click_start.mp3")
@onready var location_picker: Control = $LocationPicker

@onready var title_card_animation_player: AnimationPlayer = $"TitleCardPlayer"

func _ready():
	title_card_animation_player.play("titlemovement")
	for child in get_children():
		if child is GermOrbital:
			germ_orbital_array.push_back(child)
	
	# scope creep flu_endpoint = flu_line.points[flu_line.points.size() - 1]
	
	for orbital in germ_orbital_array:
		orbital.animation_player.play("orbit")
		await get_tree().create_timer(2).timeout
		


#scope creep below
func _physics_process(delta):
	#var orbital_pos = germ_orbital_array[0].texture_rect.get_child(0).global_position.x
	#if (( orbital_pos > 150 and orbital_pos < 800) and germ_orbital_array[0].texture_rect.z_index > 0):
		#flu_card.visible = true
	#else:
		#flu_card.visible = false
	#if (( orbital_pos > 200 and orbital_pos < 700) and germ_orbital_array[0].texture_rect.z_index > 0):
		#flu_line.visible = true
		#flu_line.points[flu_line.points.size() - 1] = germ_orbital_array[0].texture_rect.get_child(0).global_position
	#else:
		#flu_line.visible = false
	pass


func _on_start_game_pressed():
	sfx_player.stream = ui_accept_sound
	sfx_player.play()
	for germ_orbital in germ_orbital_array:
		germ_orbital.visible = false
	for button in main_menu_items:
		button.visible = false
	await get_tree().create_timer(0.2).timeout
	for panel in sub_menu_panels:
		panel.visible = true
	


func _on_cold_button_pressed():
	sfx_player.stream = ui_accept_sound
	sfx_player.play()
	location_picker.show()
	#get_tree().change_scene_to_file(main_scene)
