extends Node2D

signal clicked(deck: Node2D)

var _t: float

func _process(delta: float) -> void:
	_t += delta
	
	if int(_t)	== 5:
		$AnimatedSprite2D.play("blink")
		_t = 0

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index:
			clicked.emit(self)
			
