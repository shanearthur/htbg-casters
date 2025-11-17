extends Node2D


const COLLISION_MASK_CARD = 1


var screen_size
var dragged_card


func _ready() -> void:
	# for determining maximum movement of card
	screen_size = get_viewport_rect().size


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# get the card being clicked and assign it as the dragged card
			var card = castcheck_for_card()
			if card:
				dragged_card = card
		else:
			dragged_card = null 


func _process(_delta: float) -> void:
	if dragged_card:
		var mouse_pos = get_global_mouse_position()
		# limit position as defined by screen_size
		dragged_card.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y))


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
	
func on_hovered_over_card(card):
	highlight_card(card, true)


func on_hovered_off_card(card):
	highlight_card(card, false)
	
	
func highlight_card(card, hovered):
	if hovered:
		# make a bit bigger
		card.scale = Vector2(1.05, 1.05)
		# bring to front
		card.z_index = 2
	else:
		# return to original size
		card.scale = Vector2(1, 1)
		# return to original depth
		card.z_index = 1
	
	
func castcheck_for_card():
	# taken from tutorial - apparently Godot's recommendation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
