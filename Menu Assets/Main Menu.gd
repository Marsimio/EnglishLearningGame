extends Node2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var title = $CanvasLayer/Title

var sound = load("res://Menu Assets/pickupCoin.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player_2d.stream = sound
	start_hover()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mn_l_button_pressed():
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	get_tree().change_scene_to_file("res://Scenes/MnLScene.tscn")
	pass # Replace with function body.


func _on_p_1w_button_pressed():
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	get_tree().change_scene_to_file("res://Scenes/3P1W.tscn")
	pass # Replace with function body.


func _on_ft_w_button_pressed():
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	get_tree().change_scene_to_file("res://Scenes/FtW.tscn")
	pass # Replace with function body.

func start_hover():
	var tween = create_tween()
	var titleX = title.position.x
	var titleY = title.position.y
	tween.set_loops() 
	tween.tween_property(title, "position", Vector2(titleX,titleY-10), 2)
	tween.tween_property(title, "position", Vector2(titleX,titleY+10), 2)
