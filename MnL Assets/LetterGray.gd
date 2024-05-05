extends TextureRect

@onready var label = $Label
@onready var texture_rect = $"."
var completed = false

func set_text(letter):
	label.text = letter

func _can_drop_data(at_position, data):
	var correct = data.get_parent()
	if label.text == data.text and !completed:
		return true
	else:
		return false

func _drop_data(position, data):
	var correct = data.get_parent()
	completed = true
	texture_rect.texture = correct.texture
	label.visible = true
	correct.queue_free()
	GameManager.score_emitted.emit()
	SoundEffect.stream = load("res://Assets/Correct.wav")
	SoundEffect.play()

