extends Node
class_name Card

@export var card_resource: CardResource
@onready var sprite_2d: TextureRect = $TextureRect

var sprite_start_scale_x: float
var sprite_start_scale_y: float
var hover_scale_factor: float = 1.3
var hover_scale_time: float = 0.3

@onready var adder: Label = $TextureRect/Adder
@onready var card_name: Label = $TextureRect/Card_Name
@onready var description: Label = $TextureRect/Description
@onready var rarity: Label = $TextureRect/Rarity
@onready var multiplier: Label = $TextureRect/Multiplier
@onready var germ_image: TextureRect = $TextureRect/Germ_Image
@onready var card_image: TextureRect = $TextureRect/Card_Image

# Called when the node enters the scene tree for the first time.
func _ready():
	build_card()
	sprite_start_scale_x = sprite_2d.scale.x
	sprite_start_scale_y = sprite_2d.scale.y

	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func build_card():
	#if card_resource.multipler != null:
	multiplier.text = str(card_resource.multipler) + "X"
	
	#if card_resource.adder != null:
	adder.text = str(card_resource.adder) + "+"
		
	card_name.text = card_resource.name
	description.text = card_resource.description
	card_image.texture = card_resource.card_image
	germ_image.texture = card_resource.germ_image
	
	# based off of card rarity update the backing and letter
	match card_resource.rarity:
		card_resource.Rarity.COMMON:
			rarity.text = "C"
		card_resource.Rarity.RARE:
			rarity.text = "R"
		card_resource.Rarity.LEGENDARY:
			rarity.text = "L"

func _on_mouse_entered():
	var scale_tween = get_tree().create_tween()

	sprite_2d.z_index = 1

	(
		scale_tween
		. tween_property(
			sprite_2d,
			"scale",
			Vector2(
				sprite_start_scale_x * hover_scale_factor, sprite_start_scale_y * hover_scale_factor
			),
			hover_scale_time
		)
		. set_trans(Tween.TRANS_LINEAR)
	)


func _on_mouse_exited():
	var scale_tween = get_tree().create_tween()

	sprite_2d.z_index = 0

	(
		scale_tween
		. tween_property(
			sprite_2d,
			"scale",
			Vector2(sprite_start_scale_x, sprite_start_scale_y),
			hover_scale_time
		)
		. set_trans(Tween.TRANS_LINEAR)
	)
