extends Resource
class_name CardResource

enum Rarity { COMMON, RARE, LEGENDARY }

enum CardType { POPULATION, DISEASE, ADDER }

@export var card_image: Texture2D
@export var base_damage: int
@export var card_type: CardType
@export var color: Color
@export var description: String
@export var infection_multiplier: int
@export var name: String
@export var rarity: Rarity


func _init(
	p_card_image = null,
	p_base_damage = 0,
	p_card_type = CardType.POPULATION,
	p_color = Color(1, 1, 1, 1),
	p_description = "",
	p_infection_multiplier = 0,
	p_name = "",
	p_rarity = Rarity.COMMON
):
	card_image = p_card_image
	base_damage = p_base_damage
	card_type = p_card_type
	color = p_color
	description = p_description
	infection_multiplier = p_infection_multiplier
	name = p_name
	rarity = p_rarity


func apply_special_effect():
	print("{0} has no special effect yet!".format(name))
