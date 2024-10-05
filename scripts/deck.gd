extends Node
class_name Deck

var cards: Array[CardResource] = []
@export var deck_resource: DeckResource

func _ready():
    for card in deck_resource.cards:
        cards.append(card)

func shuffle():
    randomize()
    cards.shuffle()

func draw_card():
    if cards.size() > 0:
        var card = cards.pop_front()
        return card
    else:
        return null
