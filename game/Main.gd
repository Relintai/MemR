extends Control

var _menu : Control
var _settings : Control
var _sort : Control
var _folder_setup_error_popup : AcceptDialog

func hide_all() -> void:
	_menu.hide()
	_settings.hide()
	_sort.hide()

func apply_shink() -> void:
	if !ProjectSettings.get("display/window/stretch/shrink_override"):
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(900, 1000), clamp(OS.get_screen_dpi() / 72.0, 1, 3))
	else:
		var shrink_override_value : float = ProjectSettings.get("display/window/stretch/shrink_override_value")
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(900, 1000), shrink_override_value)
		
func _on_Sort_pressed() -> void:
	if !_sort.validate_folders():
		_folder_setup_error_popup.popup_centered()
		return
		
	hide_all()
	_sort.show()

func _on_Settings_pressed() -> void:
	hide_all()
	_settings.show()

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_menu = get_node("Menu")
		_settings = get_node("Settings")
		_sort = get_node("Sort")
		_folder_setup_error_popup = get_node("Control/FolderSetupError")

func _on_Settings_back() -> void:
	hide_all()
	_menu.show()
