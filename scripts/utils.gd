extends Node

@onready var Card = preload("res://scenes/card.tscn")
@onready var CardAtlas = preload("res://assets/atlases/cards.png")

func chunkify(array: Array, n: int) -> Array:
	var chunks = []
	var chunk_size = ceil(float(array.size()) / n)
	
	for i in range(n):
		var chunk = array.slice(0, chunk_size)
		chunks.append(chunk)
		array = array.slice(chunk_size, array.size()) # Update array by removing the used chunk
	
	return chunks

func generate_card_sprites_from_atlas() -> Array[AtlasTexture]:
	var card_atlas_size = CardAtlas.get_size()
	var card_sprite_size = Vector2(33, 45)
	var num_columns = int(card_atlas_size.x / card_sprite_size.x)
	var sprites: Array[AtlasTexture] = []
	
	for y_coords in range(int(card_atlas_size.y/card_sprite_size.y)):
		for x_coords in range(num_columns):
			var frame_tex = AtlasTexture.new()
			frame_tex.atlas = CardAtlas
			frame_tex.region = Rect2(Vector2(x_coords,y_coords)*card_sprite_size,card_sprite_size)
			sprites.append(frame_tex)
			
	return sprites
