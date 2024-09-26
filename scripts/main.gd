extends Node2D

@onready var Game = preload("res://scenes/game.tscn")
	
func _on_play_button_button_up() -> void:
	$StartUI.queue_free()
	add_child(Game.instantiate())
	
	
	
