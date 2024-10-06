extends Node
class_name FlippableCard

var card_resource: CardResource

func _ready():
    pass

static func new_card(p_card_resource: CardResource) -> FlippableCard:
    var card = FlippableCard.new()
    card.card_resource = p_card_resource

    var card_scene = Base_Card.new_card(p_card_resource)
    card_scene.mouse_filter = Control.MOUSE_FILTER_PASS

    card.add_child(card_scene)

    return card
