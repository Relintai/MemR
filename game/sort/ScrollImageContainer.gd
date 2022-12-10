extends PanelContainer

export(NodePath) var zoom_slider_path : NodePath

var mouse_down : bool = false
var mouse_pointer : int = 0

var hscrollbar : HScrollBar
var vscrollbar : VScrollBar

var zoom : float = 1

var _zoom_slider : VSlider

func update_zoom_to_fit_width() -> void:
	var cs : Vector2 = get_tex_size()
	
	if cs.x < 0.0000001 || cs.y < 0.0000001:
		_zoom_slider.value = 1
		return
	
	var max_axis : int = cs.max_axis()
	
	if max_axis == Vector2.AXIS_X:
		_zoom_slider.value = get_parent().rect_size.x / cs.x
	else:
		_zoom_slider.value = get_parent().rect_size.y / cs.y

func _gui_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	
	if event is InputEventMouseButton:
		var iemb : InputEventMouseButton = event
		
		if iemb.button_index == BUTTON_WHEEL_UP:
			_zoom_slider.value += 0.03
		elif iemb.button_index == BUTTON_WHEEL_DOWN:
			_zoom_slider.value -= 0.03
		else:
			mouse_down = iemb.pressed
			mouse_pointer == event.button_index
			
		accept_event()
		
	elif event is InputEventMouseMotion:
		var iemm : InputEventMouseMotion = event
		
		if !mouse_down || mouse_pointer != event.device:
			return
		
		hscrollbar.value -= iemm.relative.x
		vscrollbar.value -= iemm.relative.y
		accept_event()

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		var sc : ScrollContainer = get_parent()
		
		hscrollbar = sc.get_h_scrollbar()
		vscrollbar = sc.get_v_scrollbar()
		
		_zoom_slider = get_node(zoom_slider_path)
		
func udpate_minimum_size() -> void:
	var active_node : Control
	for c in get_children():
		if c.is_visible_in_tree():
			active_node = c
			break
	
	var cs : Vector2 = get_tex_size()
	
	cs.x *= zoom
	cs.y *= zoom

	rect_min_size = cs

func get_tex_size() -> Vector2:
	var active_node : Control
	for c in get_children():
		if c.is_visible_in_tree():
			active_node = c
			break
	
	var cs : Vector2 = Vector2(0, 0)
	
	if active_node is TextureRect:
		var tr : TextureRect = active_node as TextureRect
	
		cs = Vector2(tr.texture.get_width(), tr.texture.get_height())

	return cs

func _on_ZoomSlider_value_changed(value: float) -> void:
	if value < 0.00000001:
		value = 0.00000001
	
	zoom = value
	udpate_minimum_size()
