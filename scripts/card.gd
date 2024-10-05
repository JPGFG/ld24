extends Node
class_name Card

@export var card_resource: CardResource
@onready var sprite_2d: ColorRect = $"ColorRect"

var sprite_start_scale_x: float
var sprite_start_scale_y: float
var hover_scale_factor: float = 1.1
var hover_scale_time: float = 0.3


@onready var multiplier: Label = $Multiplier
@onready var adder: Label = $Adder
@onready var card_name: Label = $Card_Name
@onready var rarity: Label = $Rarity
@onready var description: Label = $Description

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplier.text = str(card_resource.multipler)
	adder.text = str(card_resource.adder)
	card_name.text = card_resource.name
	description.text = card_resource.description
	
	sprite_start_scale_x = sprite_2d.scale.x
	sprite_start_scale_y = sprite_2d.scale.y

	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)


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
