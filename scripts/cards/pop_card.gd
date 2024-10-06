extends Base_Card
class_name Pop_Card

@onready var adder: Label = $TextureRect/Adder
@onready var card_name: Label = $TextureRect/Card_Name
@onready var description: Label = $TextureRect/Description
@onready var rarity: Label = $TextureRect/Rarity
@onready var multiplier: Label = $TextureRect/Multiplier
@onready var germ_image: TextureRect = $TextureRect/Germ_Image
@onready var card_image: TextureRect = $TextureRect/Card_Image

func _ready() -> void:
	build_card()
	super()

func build_card():
	if card_resource.multiplier != null and card_resource.adder != 0:
		multiplier.text = str(card_resource.multiplier) + "X"
	else:
		adder.visible = false
	
	if card_resource.adder != null and card_resource.adder != 0:
		adder.text = str(card_resource.adder) + "+"
	else:
		adder.visible = false
		
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
