extends Node2D

@onready var Card = preload("res://scenes/card.tscn")
@onready var viewport_size = get_viewport().size

const cardMap = ["C", "P", "Q", "F"]

var card_sprites_by_type
var current_round = 0

func _ready() -> void:
	card_sprites_by_type = Utils.chunkify(Utils.generate_card_sprites_from_atlas(), 4)
	make_card(3)

	

func make_card(count: int) -> void:
	print("Making %d cards..." % count)
	for i in range(count):
		var card = Card.instantiate()
		card.name = "Card" + str(randi())
		add_child(card)
		
		var sprite = card.get_node("Sprite")
		var initial_tween = create_tween()
		var up_down_tween = create_tween().bind_node(card)
		
		card.position = $Deck.position
		
		initial_tween.tween_property(card, "global_position", Vector2(-44.5 + i*32, 0), 1.25).set_delay(i * 0.5)
		initial_tween.tween_callback(card.clicked.connect.bind(_on_card_clicked))
		
		up_down_tween.tween_property(sprite, "position", position - Vector2(0, 2), .8).as_relative()
		up_down_tween.tween_property(sprite, "position", position + Vector2(0, 2), .8).as_relative()
		up_down_tween.set_loops(INF)
		
func get_score() -> int:
	return int($UI/Points.text.split("/", true)[0])
	
func set_score(new_score: int) -> void:
	$UI/Points.text = "%d/21" % new_score
	
func _on_card_clicked(card: Node2D):
	if card.flipped:
		var score;
		match card.card_idx:
			0:
				score = 11 if get_score() + 11 < 21 else 1
			_:
				score = card.card_idx
		set_score(get_score() + score)
		
		for c in get_children():
			print(c.name)
			if c.name.substr(0,4) == "Card":
				c.clicked.disconnect(_on_card_clicked)
				if c.get_instance_id() == card.get_instance_id():
					continue
				var tw = create_tween().bind_node(c)
				var sp = c.get_node("Sprite")
				
				tw.tween_property(sp, "scale", Vector2(), 1)
				tw.tween_callback(c.queue_free)
				
		var tween = create_tween().bind_node(card)
		var sprite = card.get_node("Sprite")
		
		tween.parallel().tween_property(sprite, "scale", Vector2(), 1)
		tween.parallel().tween_property(sprite, "rotation_degrees", 360, 1)
		tween.tween_callback(card.queue_free)
		tween.tween_callback(make_card.bind(3))
		
		current_round += 1
		handle_new_score()
		return
		
	card.flipped = true
	
	var card_group_idx = randi() % card_sprites_by_type.size()
	var card_group = card_sprites_by_type[card_group_idx]
	var card_idx = randi() % card_group.size()
	
	card.card_group_idx = card_group_idx
	card.card_idx = card_idx
	
	card.get_node("Sprite").texture = card_group[card_idx]
	
func handle_new_score():
	if(get_score() > 21):
		print("You lost!")
#For testing purposes
#func alternate_all_cards(card: Node2D):
	#for j in range(card_sprites_by_type.size()):
		#for k in range(card_sprites_by_type[j].size()):
			#card.get_node("Sprite").texture = card_sprites_by_type[j][k]
			#await get_tree().create_timer(.5).timeout
