extends Node
class_name Hand

var cards: Array[CardResource] = [null, null, null, null, null]
@onready var game_controller: GameController = get_node("/root/Gameboard/GameController")
@onready var game_board: Control = get_node("/root/Gameboard")

var deck: Deck:
	get:
		return game_controller.deck


func add_card(card: CardResource):
	var first_null_index = cards.find(null)

	cards[first_null_index] = card

	var card_container = get_card_container_at_position(first_null_index)

	var card_scene = Base_Card.new_card(card)
	card_scene.position_in_hand = first_null_index

	var flippable_card = FlippableCard.new_card(card)
	game_board.add_child(flippable_card)
	await flippable_card.flip_card_in(card_container, deck)

	card_container.add_child(card_scene)


func get_card_container_at_position(position: int) -> Node:
	var child_containers = get_children()
	return child_containers[position]


func remove_card(card: Base_Card):
	cards[card.position_in_hand] = null
