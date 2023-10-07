extends StaticBody2D

var occupied = false
var hover_color = Color(Color.MEDIUM_ORCHID, 0.7)
var default_color = Color(Color.SANDY_BROWN, 0.2)


func begin_hover():
	modulate = hover_color
	
func end_hover():
	modulate = default_color
	
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = default_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.is_dragging:
		visible = true
	else:
		visible = false
