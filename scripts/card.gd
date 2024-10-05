extends Node

@export var card_resource: CardResource

@onready var multiplier: Label = $Multiplier
@onready var adder: Label = $Adder
@onready var card_name: Label = $Card_Name
@onready var rarity: Label = $Rarity
@onready var description: Label = $Description

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplier.text = str(card_resource.multipler)
	adder.text = str(card_resource.adder)
	card_name.text = card_resource.name
	description.text = card_resource.description
	
