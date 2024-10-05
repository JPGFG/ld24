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

var selected_card:Base_Card = null

@onready var pop_slot: MarginContainer = get_node("/root/Gameboard/battleground/PopCardSlot")
@onready var pop_button: Button = get_node("/root/Gameboard/battleground/PopCardSlot/PopCardButton")
@onready var germ_slot: MarginContainer =  get_node("/root/Gameboard/battleground/GermCardSlot")
@onready var germ_button: Button = get_node("/root/Gameboard/battleground/GermCardSlot/GermCardButton")
@export var util_buttons : Array[Button]

func _ready():
	for button in util_buttons:
		button.pressed.connect(self._on_util_button_pressed.bind(button))
		
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


func set_selected_card(card:Base_Card):
	
	if(card.get_parent() is MarginContainer):
		card.reparent(card.parent_control, false)
		selected_card = null
		return
		
	if(selected_card == card):
		card.reparent(card.parent_control, false)
		selected_card = null
	else:
		selected_card = card

func _on_pop_card_button_pressed():
	if(selected_card):
		if(selected_card.card_resource.card_type != CardResource.CardType.POPULATION):
			print("error: Not a Population Card type")
			return
		selected_card.reparent(pop_slot, false)
		selected_card = null


func _on_germ_card_button_pressed():
	if(selected_card):
		if(selected_card.card_resource.card_type != CardResource.CardType.DISEASE):
			print("error: Not a Disease Card type")
			return
		selected_card.reparent(germ_slot, false)
		selected_card = null


func _on_util_button_pressed(button):
	if(selected_card):
		if(selected_card.card_resource.card_type != CardResource.CardType.ADDER):
			print("error: Not a Utility Card type")
			return
		selected_card.reparent(button.get_parent(), false)
		selected_card = null
