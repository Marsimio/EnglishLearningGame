extends TextureRect
 
@onready var label = $Label

func set_text(letter):
	label.text = letter

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
	visible = false
	return label

func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			visible = true
