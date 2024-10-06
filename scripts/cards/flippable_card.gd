extends Node2D
class_name FlippableCard

var card_resource: CardResource
var card_front: Control

var tween_duration: float = 0.3

func flip_card_in(card_container: Control, deck: Deck):
	
	var card_back = get_node("CardBack")

	global_position = deck.global_position

	card_front.size = deck.size
	card_front.pivot_offset = Vector2(deck.size.x / 2, deck.size.y / 2)

	card_back.size = deck.size
	card_back.pivot_offset = Vector2(deck.size.x / 2, deck.size.y / 2)

	var end_size = card_container.size
	var end_position = card_container.global_position

	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.finished.connect(_on_tween_finished)

	tween.tween_property(self, "global_position", end_position, tween_duration).set_trans(
		Tween.TRANS_LINEAR
	)
	(
		tween
		. tween_property(card_back, "scale", Vector2(0, 1), tween_duration / 2)
		. set_trans(Tween.TRANS_LINEAR)
	)
	tween.tween_property(card_back, "size", end_size, tween_duration).set_trans(
		Tween.TRANS_LINEAR
	)
	(
		tween
		. tween_property(card_front, "scale", Vector2(1, 1), tween_duration)
		. set_trans(Tween.TRANS_LINEAR)
		. set_delay((tween_duration / 2) - 0.1)
	)
    
	await get_tree().create_timer(0.3).timeout

func _on_tween_finished():
	queue_free()

static func new_card(p_card_resource: CardResource) -> FlippableCard:
	var card = preload("res://scenes/cards/flippable_card.tscn").instantiate()
	card.card_resource = p_card_resource

	var card_scene = Base_Card.new_card(p_card_resource)
	card_scene.mouse_filter = Control.MOUSE_FILTER_PASS

	card.add_child(card_scene)
	card.card_front = card_scene
	card.card_front.scale = Vector2(0, 1)

	return card