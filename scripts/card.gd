extends Node2D

@export var flipped: bool
@export var card_idx: int
@export var card_group_idx: int

signal clicked(card: Node2D)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
