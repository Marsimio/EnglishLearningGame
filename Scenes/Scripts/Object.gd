extends TextureRect

func _ready():
	start_hover()

func start_hover():
	var tween = create_tween()
	var X = position.x
	var Y = position.y
	tween.set_loops() 
	tween.tween_property(self, "position", Vector2(X,Y-10), 2)
	tween.tween_property(self, "position", Vector2(X,Y+10), 2)
