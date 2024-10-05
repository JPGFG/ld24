class_name GameController

extends Node

##exported properties are temporary for debugging purposes.

@export var ui_controller : UIController

var pops = []
@export var hand: Hand
@export var deck: Deck
var graveyard = []
var resistances = []

var turns : int
var school_life : int

func _ready():
	await get_tree().create_timer(1.0).timeout
	draw_cards()

func draw_cards():
	while !deck.ready:
		await deck.ready

	deck.shuffle()
	while (hand.cards.size() < 5 ):
		if deck.cards.size() != 0:
			var card_index = hand.cards.size()
			var drawn_card = deck.draw_card()
			await hand.add_card(drawn_card, card_index)
		else:
			print("your deck is empty")
			return
