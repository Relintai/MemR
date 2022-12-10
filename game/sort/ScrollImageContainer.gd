extends VBoxContainer

var mouse_down : bool = false
var mouse_pointer : int = 0

var hscrollbar : HScrollBar
var vscrollbar : VScrollBar

func _gui_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	
	if event is InputEventMouseButton:
		var iemb : InputEventMouseButton = event
		
		mouse_down = iemb.pressed
		mouse_pointer == event.device
		
	elif event is InputEventMouseMotion:
		var iemm : InputEventMouseMotion = event
		
		if !mouse_down || mouse_pointer != event.device:
			return
		
		hscrollbar.value -= iemm.relative.x
		vscrollbar.value -= iemm.relative.y

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		var sc : ScrollContainer = get_parent()
		
		hscrollbar = sc.get_h_scrollbar()
		vscrollbar = sc.get_v_scrollbar()
