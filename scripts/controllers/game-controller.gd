class_name GameController

extends Node

##exported properties are temporary for debugging purposes.

@export var ui_controller : UIController

var pops = []
@export var hand: Hand
@export var deck: Deck
var graveyard = []
var resistances = []

var turns : int = 3
@onready var turns_ui : Label = get_node("/root/Gameboard/turnwarning/Label")
var school_life : int = 100
@onready var school_life_ui : Label = get_node("/root/Gameboard/enemystats/Label")

var selected_card:Base_Card = null

@onready var pop_slot: MarginContainer = get_node("/root/Gameboard/battleground/PopCardSlot")
@onready var pop_button: Button = get_node("/root/Gameboard/battleground/PopCardSlot/PopCardButton")
@onready var germ_slot: MarginContainer =  get_node("/root/Gameboard/battleground/GermCardSlot")
@onready var germ_button: Button = get_node("/root/Gameboard/battleground/GermCardSlot/GermCardButton")
@export var util_buttons : Array[Button]

var played_hand : Array[Base_Card]

@onready var deploy_button: Button = get_node("/root/Gameboard/deploybutton")

func _ready():
	update_stats_ui()
	
	for button in util_buttons:
		button.pressed.connect(self._on_util_button_pressed.bind(button))
		
	await get_tree().create_timer(1.0).timeout
	draw_cards()

func draw_cards():
	while !deck.ready:
		await deck.ready

	deck.shuffle()
	while (hand.cards.find(null) != -1):
		if deck.cards.size() != 0:
			var drawn_card = deck.draw_card()
			await hand.add_card(drawn_card)
		else:
			print("your deck is empty")
			return


func set_selected_card(card:Base_Card):
	
	if(card.get_parent() is MarginContainer):
		card.reparent(card.parent_control, false)
		var index = played_hand.find(card, 0)
		if index != -1: played_hand.remove_at(index)
		selected_card = null
		print (played_hand)
		return
		
	if(selected_card == card):
		card.reparent(card.parent_control, false)
		var index = played_hand.find(card, 0)
		if index != -1: played_hand.remove_at(index)
		selected_card = null
		print(played_hand)
	else:
		selected_card = card

func _on_pop_card_button_pressed():
	if(selected_card):
		if(selected_card.card_resource.card_type != CardResource.CardType.POPULATION):
			print("error: Not a Population Card type")
			return
		selected_card.reparent(pop_slot, false)
		played_hand.push_back(selected_card)
		selected_card = null
		print(played_hand)


func _on_germ_card_button_pressed():
	if(selected_card):
		if(selected_card.card_resource.card_type != CardResource.CardType.DISEASE):
			print("error: Not a Disease Card type")
			return
		played_hand.push_back(selected_card)
		selected_card.reparent(germ_slot, false)
		selected_card = null
		print (played_hand)


func _on_util_button_pressed(button):
	if(selected_card):
		if(selected_card.card_resource.card_type != CardResource.CardType.ADDER):
			print("error: Not a Utility Card type")
			return
		played_hand.push_back(selected_card)
		selected_card.reparent(button.get_parent(), false)
		selected_card = null
		print(played_hand)


func _on_deploybutton_pressed():
	if(played_hand == []):
		print("No Empty Deployments!")
		return
	compute()

func compute():
	var base_germ_damage
	var pop_multiplier
	var utility_additives
	
	for card in played_hand:
		if(card.card_resource.card_type == CardResource.CardType.POPULATION):
			pop_multiplier = card.card_resource.multiplier
			print("population multiplier: " + str(pop_multiplier))
		if(card.card_resource.card_type == CardResource.CardType.DISEASE):
			base_germ_damage = card.card_resource.adder
			print("base damage: " + str(base_germ_damage))
			
	##Needs Util Implementation
	var damage_total
	if(base_germ_damage && pop_multiplier):
		damage_total = base_germ_damage * pop_multiplier
	print("school life: " + str(school_life))
	school_life -= damage_total
	print("damage total: " + str(damage_total))
	print("new school life: " + str(school_life))
	turns-=1
	update_stats_ui()
	discard()

func discard():
	for card in played_hand:
		graveyard.push_back(card)
		hand.remove_card(card)
		card.queue_free()
	played_hand.clear()
	print(played_hand)
	print(graveyard)
	draw_cards()

func update_stats_ui():
	school_life_ui.text = "School Life: " + str(school_life)
	turns_ui.text = "Turns Remaining: " + str(turns)
