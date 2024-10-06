extends Node
class_name Hand

var cards: Array[CardResource] = [null, null, null, null, null]

func add_card(card: CardResource):

	var first_null_index = cards.find(null)

	cards[first_null_index] = card

	var flippable_card = FlippableCard.new_card(card)
	var card_container = get_card_container_at_position(card_position)
	

	var card_scene = Base_Card.new_card(card)
	card_scene.position_in_hand = first_null_index

	card_container.add_child(card_scene)
	await get_tree().create_timer(0.3).timeout

func get_card_container_at_position(position: int) -> Node:
	var child_containers = get_children()
	return child_containers[position]

func remove_card(card: Base_Card):
	cards[card.position_in_hand] = null
