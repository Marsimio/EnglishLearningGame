extends TextureRect

@onready var label = $Label
var hovered = false

func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.z_index = 1
	preview_texture.size = Vector2(30,30)
	preview_texture.position = Vector2(-15,-15)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
 
	set_drag_preview(preview)
	return label

func _can_drop_data(at_position, data):
	hovered = true
	texture = load("res://Menu Assets/Letters/LetterIcon2.png")
