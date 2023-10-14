extends Node2D

const mouse_enter_scale = 1.05
var draggable = false
var dragging = false
var owner_ref: StaticBody2D
var origin_ref: StaticBody2D
var colliding_ref: StaticBody2D
var tween_duration = 0.2
var drag_offset: Vector2


func _ready():
	pass

func start_drag():
	drag_offset = global_position - get_global_mouse_position()
	global.set_dragged(self)
	dragging = true
	
func end_drag():
	global.clear_dragged(self)
	
	if colliding_ref != null:
		colliding_ref.occupy(self)
		if owner_ref != null:
			owner_ref.end_occupation(self)
		owner_ref = colliding_ref
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", colliding_ref.global_position, tween_duration).set_ease(Tween.EASE_OUT)
	elif owner_ref != null:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", owner_ref.global_position, tween_duration).set_ease(Tween.EASE_OUT)
	elif origin_ref != null:
		origin_ref.reclaim(self)
		
	if colliding_ref != null:
		colliding_ref.end_hover()
		
	colliding_ref = null
	dragging = false
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if draggable:
		if Input.is_action_just_pressed("click"):
			start_drag()
			
	if dragging:
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() + drag_offset
			
		elif Input.is_action_just_released("click"):
			end_drag()

func _on_area_2d_mouse_entered():
	if not global.is_dragging && not Input.is_action_pressed("click"):
		draggable = true
		scale = Vector2(mouse_enter_scale, mouse_enter_scale)

func _on_area_2d_mouse_exited():
	if draggable && not dragging:
		print("Mouse exited")
		draggable = false
		scale = Vector2.ONE


func _on_area_2d_body_entered(body: StaticBody2D):
	if body.is_in_group("droppable") and body.can_occupy(self):		
		body.begin_hover()
		if (colliding_ref != null):
			colliding_ref.end_hover()
		colliding_ref = body


func _on_area_2d_body_exited(body):
	if body == colliding_ref:
		colliding_ref = null
		body.end_hover()


func set_origin(body: StaticBody2D):
	origin_ref = body


func is_origin(body: StaticBody2D):
	return body == origin_ref
	
func recycle():
	if origin_ref != null:
		origin_ref.reclaim(self)
