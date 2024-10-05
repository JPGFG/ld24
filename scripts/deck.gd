extends Node
class_name Deck

var cards: Array[CardResource] = []

func _ready():
    var card_resources = Helper.get_all_resource_paths("res://resources/cards/populations", false)
    print(card_resources)
    var resources_size = card_resources.size()
    for i in range(10):
        var random_resource = card_resources[randi() % resources_size]
        var card = load(random_resource)
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
