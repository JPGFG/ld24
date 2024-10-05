extends Resource
class_name DeckResource

@export var cards: Array[CardResource]

func _init(p_cards: Array[CardResource] = []):
    cards = p_cards