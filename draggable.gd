extends Node2D

const mouse_enter_scale = 1.05
var draggable = false
var dragging = false
var owner_ref: StaticBody2D
var body_ref: StaticBody2D
var tween_duration = 0.2
var drag_offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if draggable:
		if Input.is_action_just_pressed("click"):
			drag_offset = global_position - get_global_mouse_position()
			global.is_dragging = true
			dragging = true
			
	if dragging:
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() + drag_offset
			
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			
			if body_ref != null:
				body_ref.occupied = true
				if owner_ref != null:
					owner_ref.occupied = false
				owner_ref = body_ref
				var tween = get_tree().create_tween()
				tween.tween_property(self, "global_position", body_ref.global_position, tween_duration).set_ease(Tween.EASE_OUT)
			elif owner_ref != null:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "global_position", owner_ref.global_position, tween_duration).set_ease(Tween.EASE_OUT)

			if body_ref != null:
				body_ref.end_hover()
				
			body_ref = null
			dragging = false

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
	if body.is_in_group("droppable") and not body.occupied:		
		body.begin_hover()
		if (body_ref != null):
			body_ref.end_hover()
		body_ref = body


func _on_area_2d_body_exited(body):
	if body == body_ref:
		body_ref = null
		body.end_hover()
