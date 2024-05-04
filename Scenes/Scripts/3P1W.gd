extends Node2D

@onready var h_box_container = $CanvasLayer/Title/HBoxContainer
@onready var v_box_container = $CanvasLayer/VBoxContainer
@onready var progress_bar = $CanvasLayer/ProgressBar
@onready var object = $CanvasLayer/Object
@onready var object_2 = $CanvasLayer/Object2
@onready var object_3 = $CanvasLayer/Object3

var sound = load("res://Assets/pickupCoin.wav")

var objects = [
	{"name": "apple", "image1": preload("res://MnL Assets/Food/Apple.png"), "image2": preload("res://MnL Assets/Food/Apple.png"), "image3": preload("res://MnL Assets/Food/Apple.png")},
	{"name": "banana", "image1": preload("res://MnL Assets/Food/Apple.png"), "image2": preload("res://MnL Assets/Food/Apple.png"), "image3": preload("res://MnL Assets/Food/Apple.png")},
	{"name": "orange", "image1": preload("res://MnL Assets/Food/Apple.png"), "image2": preload("res://MnL Assets/Food/Apple.png"), "image3": preload("res://MnL Assets/Food/Apple.png")}
]

var current_object_index = 0
var hint = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.score_emitted.connect(check_completion)
	progress_bar.max_value = objects.size()
	load_object(objects[current_object_index])

func load_object(obj):
	object.texture = obj.image1
	object_2.texture = obj.image2
	object_3.texture = obj.image3
	setup_green_letters(obj.name)
	setup_gray_letters(obj.name)

func setup_green_letters(name):
	for child in v_box_container.get_children():
		child.queue_free()
	for letter in name:
		var green_letter = preload("res://MnL Assets/Letter.tscn").instantiate()
		v_box_container.add_child(green_letter)
		green_letter.set_text(letter)
	shuffle_children(v_box_container)

func setup_gray_letters(name):
	for child in h_box_container.get_children():
		child.queue_free()
	for letter in name:
		var gray_letter = preload("res://MnL Assets/LetterGray.tscn").instantiate()
		h_box_container.add_child(gray_letter)
		gray_letter.set_text(letter)
		gray_letter.label.visible = false

func check_completion():
	if all_letters_correct():
		current_object_index += 1
		GameManager.score += 1
		progress_bar.value += 1
		hint = false
		if current_object_index >= objects.size():
			await SoundEffect.finished
			get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
		else:
			load_object(objects[current_object_index])

func all_letters_correct():
	var correct_letters_count = 0
	var name = objects[current_object_index]["name"]
	for i in range(h_box_container.get_child_count()):
		var letter = h_box_container.get_child(i)
		if letter.completed == true:
			correct_letters_count += 1
	return correct_letters_count == name.length()

func shuffle_children(container):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var child_count = container.get_child_count()
	for i in range(child_count - 1, 0, -1):
		var j = rng.randi_range(0, i)
		container.move_child(container.get_child(i), j)

func _on_button_pressed():
	SoundEffect.stream = sound
	SoundEffect.play()
	await SoundEffect.finished
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_button_2_pressed():
	if hint == false:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var child_count = h_box_container.get_child_count()
		while hint == false:
			var random_index = rng.randi_range(0, child_count - 1)
			if h_box_container.get_child(random_index).completed == false:
				h_box_container.get_child(random_index).label.visible = true
				hint = true
