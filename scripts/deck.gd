extends Node
class_name Deck

var cards: Array[CardResource] = []
@export var deck_resource: DeckResource
@onready var deck_count: Label = $DeckCount

func _ready():
	for card in deck_resource.cards:
		cards.append(card)
	
	deck_count.text = str(cards.size())

func shuffle():
	randomize()
	cards.shuffle()

func draw_card():
	if cards.size() > 0:
		var card = cards.pop_front()
		deck_count.text = str(cards.size())
		return card
	else:
		return null
