extends Node2D

var words = [
	{"name":"ACORNS", "sound": preload("res://Menu Assets/FtW Assets/Acorns.wav")},
	{"name": "BANANA", "sound": preload("res://Menu Assets/FtW Assets/Banana.wav")}
	]
	
var grid_size = 6
var letters = []
var grid = []
var sound = load("res://Assets/pickupCoin.wav")

@onready var progress_bar = $CanvasLayer/ProgressBar
@onready var grid_container = $CanvasLayer/Title/GridContainer


func _ready():
	startup()
	
func startup():
	setup_grid()
	place_words()
	update_grid_labels()

func setup_grid():
	grid = []
	for child in grid_container.get_children():
		child.queue_free()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(grid_size):
		grid.append([])
		for j in range(grid_size):
			var gray_letter = preload("res://Menu Assets/FtW Assets/CrossWordLetter.tscn").instantiate()
			grid_container.add_child(gray_letter)
			grid[i].append(gray_letter)

func place_words():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var placed = false
	while !placed:
		var direction = rng.randi_range(0, 1)  # 0: horizontal, 1: vertical,
		var x = rng.randi_range(0, grid_size - 1)
		var y = rng.randi_range(0, grid_size - 1)
		placed = try_place_word(words[progress_bar.value].name, x, y, direction)

func try_place_word(word, x, y, direction):
	var word_length = word.length()
	if direction == 0:
		for i in range(word_length):
			grid[x][0+i].label.text = word[i]
		return true
	elif direction == 1:
		for i in range(word_length):
			grid[0+i][y].label.text = word[i]
		return true

func update_grid_labels():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(grid_size):
		for j in range(grid_size):
			if grid[i][j].label.text == "":
				grid[i][j].label.set_text(char(rng.randi_range(65, 90)))

func char(num):
	return char(int(num))

func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			for i in range(grid_size):
				for j in range(grid_size):
					if grid[i][j].hovered:
						letters.append(grid[i][j].label.text)
						grid[i][j].hovered = false
					grid[i][j].texture = load("res://Menu Assets/Letters/LetterIcon.png")
			letter_check()

func letter_check():
	var result = "".join(letters)
	var result_r = result.reverse()
	var resultFound = false
	for word in words:
		if word.name == result or word.name == result_r:
			resultFound = true
			break
	if resultFound:
		SoundEffect.stream = sound
		SoundEffect.play()
		progress_bar.value += 1
		if progress_bar.value >= words.size():
			await SoundEffect.finished
			get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
		else:
			startup()
	else:
		letters.clear()

func _on_button_pressed():
	SoundEffect.stream = sound
	SoundEffect.play()
	await SoundEffect.finished
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_button_2_pressed():
	if progress_bar.value < words.size():
		SoundEffect.stream = words[progress_bar.value].sound
		SoundEffect.play()
