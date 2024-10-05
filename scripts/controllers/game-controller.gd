class_name GameController

extends Node

##exported properties are temporary for debugging purposes.

@export var ui_controller : UIController

var pops = []
@onready var hand = [ "fat", "buttholes", "make", "me"]
@onready var deck = ["cholera", "cold"]
var graveyard = []
var resistances = []

var turns : int
var school_life : int

func _ready():
	pass


func shuffle_deck():
	randomize()
	deck.shuffle()
	return

func draw_cards():
	while (hand.size() < 7 ):
		if deck!= []:
			var drawnCard = deck.pop_back()
			hand.push_back(drawnCard)
		else:
			print("your deck is empty")
			return
