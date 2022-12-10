extends PanelContainer

var mouse_down : bool = false
var mouse_pointer : int = 0

var hscrollbar : HScrollBar
var vscrollbar : VScrollBar

var zoom : float = 1

func _gui_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	
	if event is InputEventMouseButton:
		var iemb : InputEventMouseButton = event
		
		mouse_down = iemb.pressed
		mouse_pointer == event.device
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
		
func udpate_minimum_size() -> void:
	var active_node : Control
	for c in get_children():
		if c.is_visible_in_tree():
			active_node = c
			break
	
	var cs : Vector2 = Vector2(0, 0)
	
	if active_node is TextureRect:
		var tr : TextureRect = active_node as TextureRect
	
		cs = Vector2(tr.texture.get_width(), tr.texture.get_height())
		cs.x *= zoom
		cs.y *= zoom

	rect_min_size = cs

func _on_ZoomSlider_value_changed(value: float) -> void:
	if value < 0.00000001:
		value = 0.00000001
	
	zoom = value
	udpate_minimum_size()