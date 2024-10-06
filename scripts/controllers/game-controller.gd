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

var school_max_life: int = 100
var school_life : int = 100
@onready var school_life_ui : Label = get_node("/root/Gameboard/enemystats/HealthNumberDisplay")
@onready var health_bar: ProgressBar = $"../enemystats/HealthBar"

var selected_card:Base_Card = null

@onready var pop_slot: MarginContainer = get_node("/root/Gameboard/battleground/PopCardSlot")
@onready var pop_button: Button = get_node("/root/Gameboard/battleground/PopCardSlot/PopCardButton")
@onready var germ_slot: MarginContainer =  get_node("/root/Gameboard/battleground/GermCardSlot")
@onready var germ_button: Button = get_node("/root/Gameboard/battleground/GermCardSlot/GermCardButton")
@export var util_buttons : Array[Button]

@onready var win_panel: PanelContainer = get_node("/root/Gameboard/WinPanel")
var main_scene = "res://ui/start_menu.tscn"

var played_hand : Array[Base_Card]

@onready var deploy_button: Button = get_node("/root/Gameboard/deploybutton")

@onready var deploy_sfx_player: AudioStreamPlayer2D = get_node("/root/Gameboard/DeploySFXPlayer")
@onready var card_sfx_player: AudioStreamPlayer2D = get_node("/root/Gameboard/CardSFXPlayer")
@onready var deploy_sound: AudioStreamMP3 = preload("res://assets/sounds/deploy.mp3")
@onready var card_draw_sound: AudioStreamMP3 = preload("res://assets/sounds/card_slide.mp3")

func _ready():
	update_stats_ui()
	health_bar.max_value = school_life
	for button in util_buttons:
		button.pressed.connect(self._on_util_button_pressed.bind(button))
		
	await get_tree().create_timer(1.0).timeout
	draw_cards()

func draw_cards():
	while !deck.ready:
		await deck.ready

	deck.shuffle()
	while (hand.cards.find(null) != -1):
		card_sfx_player.stream = card_draw_sound
		card_sfx_player.play()
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
		print("Error: No Empty Deployments!")
		return
	deploy_sfx_player.stream = deploy_sound
	deploy_sfx_player.play()
	compute()


func compute():
	var base_germ_damage = 0
	var pop_multiplier = 1
	var utility_damage = 0
	var utility_multiplier = 0
	
	for card in played_hand:
		
		if(card.card_resource.card_type == CardResource.CardType.DISEASE):
			base_germ_damage = card.card_resource.adder
		
		if(card.card_resource.card_type == CardResource.CardType.POPULATION):
			pop_multiplier += card.card_resource.multiplier
		
		if(card.card_resource.card_type == CardResource.CardType.ADDER):
			utility_damage += card.card_resource.adder
			if(card.card_resource.multiplier != 0):
				utility_multiplier += card.card_resource.multiplier
			card.card_resource.apply_special_effect()
			
	
	if(!base_germ_damage):
		base_germ_damage = 0
	if(!pop_multiplier):
		pop_multiplier = 1
	if(!utility_damage):
		utility_damage = 0
	if(!utility_multiplier):
		0
	var multiplier_total = pop_multiplier + utility_multiplier
	var damage_total = base_germ_damage + utility_damage
	var total_attack_value = damage_total * multiplier_total
	
	updateHealthStatus(total_attack_value)
	
	turns-=1
	update_stats_ui()
	
	check_win_conditions()

func updateHealthStatus(damage: int):
	school_life -= damage
	health_bar.value = school_life


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

func check_win_conditions():
	if(school_life <= 0):
		win()
	else:
		discard()

func win():
	win_panel.visible = true


func _on_win_button_pressed():
	get_tree().change_scene_to_file(main_scene)
