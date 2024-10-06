extends Node
class_name Base_Card

@export var card_resource: CardResource
var sprite_2d: TextureRect

var sprite_start_scale_x: float
var sprite_start_scale_y: float
var hover_scale_factor: float = 1.3
var hover_scale_time: float = 0.3

@onready var game_controller: GameController = get_node("/root/Gameboard/GameController")
@onready var parent_control = get_parent()
var mouse_inside = false

var position_in_hand: int

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d = $TextureRect
	sprite_start_scale_x = sprite_2d.scale.x
	sprite_start_scale_y = sprite_2d.scale.y

	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	var scale_tween = get_tree().create_tween()
	mouse_inside = true
	sprite_2d.z_index = 1

	(
		scale_tween
		.tween_property(
			sprite_2d,
			"scale",
			Vector2(
				sprite_start_scale_x * hover_scale_factor, sprite_start_scale_y * hover_scale_factor
			),
			hover_scale_time
		)
		.set_trans(Tween.TRANS_LINEAR)
	)

func _input(event):
	if ((event is InputEventMouseButton) and event.button_index == 1 and event.pressed == true):
		if (mouse_inside):
			game_controller.set_selected_card(self)

func _on_mouse_exited():
	var scale_tween = get_tree().create_tween()
	mouse_inside = false
	sprite_2d.z_index = 0

	(
		scale_tween
		.tween_property(
			sprite_2d,
			"scale",
			Vector2(sprite_start_scale_x, sprite_start_scale_y),
			hover_scale_time
		)
		.set_trans(Tween.TRANS_LINEAR)
	)

static func new_card(p_card_resource: CardResource) -> Base_Card:
	var card: Base_Card
	match p_card_resource.card_type:
		CardResource.CardType.POPULATION:
			card = preload("res://scenes/cards/pop_card.tscn").instantiate()
		CardResource.CardType.DISEASE:
			card = preload("res://scenes/cards/germ_card.tscn").instantiate()
		CardResource.CardType.ADDER:
			card = preload("res://scenes/cards/addon_card.tscn").instantiate()
	card.card_resource = p_card_resource
	return card
