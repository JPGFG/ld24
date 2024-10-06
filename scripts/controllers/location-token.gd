extends TextureRect

var icon_has_focus = false

@export var enabled = true
@export var description_container: PanelContainer
@onready var sfx_player: AudioStreamPlayer2D = $"../../SFXPlayer"
@onready var ui_accept_sound: AudioStreamMP3 = preload("res://assets/sounds/click_start.mp3")


var sprite_start_scale_x: float = 1.25
var sprite_start_scale_y: float = 1.25
var hover_scale_factor: float = 1.5
var hover_scale_time: float = 0.3
var can_click = false

func _ready() -> void:
	if enabled == false:
		self.modulate = Color(.1, .1, .1, .8)


func _on_mouse_entered() -> void:
	can_click = true
	var scale_tween = get_tree().create_tween()
	(
		scale_tween
		.tween_property(
			self,
			"scale",
			Vector2(
				sprite_start_scale_x * hover_scale_factor, sprite_start_scale_y * hover_scale_factor
			),
			hover_scale_time
		)
		.set_trans(Tween.TRANS_LINEAR)
	)
	description_container.show()


func _on_mouse_exited() -> void:
	can_click = false
	var scale_tween = get_tree().create_tween()
	(
		scale_tween
		.tween_property(
			self,
			"scale",
			Vector2(sprite_start_scale_x, sprite_start_scale_y),
			hover_scale_time
		)
		.set_trans(Tween.TRANS_LINEAR)
	)
	description_container.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and can_click == true and enabled == true:
		sfx_player.stream = ui_accept_sound
		sfx_player.play()
		await get_tree().create_timer(0.6).timeout
		get_tree().change_scene_to_file("res://scenes/game-board/gameboard.tscn")
