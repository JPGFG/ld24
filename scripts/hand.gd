extends Node
class_name Hand

var cards: Array[CardResource] = []

func add_card(card: CardResource, card_position: int):

	print("adding card")
	cards.append(card)

	var card_scene = Base_Card.new_card(card)

	var card_container = get_card_container_at_position(card_position)

	card_container.add_child(card_scene)
	await get_tree().create_timer(0.3).timeout

func get_card_container_at_position(position: int) -> Node:
	var child_containers = get_children()
	return child_containers[position]
